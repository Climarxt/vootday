// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/add_post_to_likes/add_post_to_likes_cubit.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/post/widgets/custom_widgets.dart';
import 'package:bootdv2/screens/post/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/cubit/createcollection_cubit.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  final String fromPath;

  const PostScreen({
    super.key,
    required this.postId,
    required this.fromPath,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  Post? _post;
  User? _user;
  bool _isLoading = true;
  bool _isUserTheAuthor = false;
  List<String> _imageUrls = [];
  final Map<String, bool> _postInCollectionMap = {};
  ValueNotifier<bool> isPublicNotifier = ValueNotifier(true);
  final TextEditingController _collectionNameController =
      TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadPost();
    Future.delayed(Duration.zero, () {
      context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());
    });
    final authState = context.read<AuthBloc>().state;
    final _userId = authState.user?.uid;
    if (_userId != null) {
      _checkIfUserIsAuthor(_userId);
    } else {
      debugPrint('User ID is null');
    }

    final state = context.read<MyCollectionBloc>().state;
    final nonNullCollections = state.collections
        .where((collection) => collection != null)
        .cast<Collection>()
        .toList();
    _fetchImageUrls(nonNullCollections);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.5)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Opacity(
            opacity: 0.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_post == null || _user == null) {
      return Scaffold(
        appBar: AppBarTitle(title: _user!.username),
        body: const Center(child: Text('Post or user not found')),
      );
    }

    return BlocConsumer<MyCollectionBloc, MyCollectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBarTitle(title: _user!.username),
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildPostImage(size, _post!),
                    buildPostDetails(
                      state,
                      context,
                      _user!,
                      _post!,
                      () => _navigateToUserScreen(context, _user!),
                      _showBottomSheet,
                      _navigateToCommentScreen,
                      _addToLikesThenShowCollections,
                      widget.postId,
                      _animation,
                      _controller,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> getMostRecentPostImageUrl(String collectionId) async {
    // Add a debug print to confirm the method is called with a valid ID
    debugPrint(
        "getMostRecentPostImageUrl : Fetching image URL for collection ID: $collectionId");

    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection');

      final querySnapshot =
          await feedEventRef.orderBy('date', descending: true).limit(1).get();

      // Check if there are documents returned
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        final DocumentReference? postRef =
            data['post_ref'] as DocumentReference?;

        if (postRef != null) {
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            final postData = postDoc.data() as Map<String, dynamic>?;
            final imageUrl = postData?['imageUrl'] as String? ?? '';
            // Print the image URL to verify it's the correct one
            debugPrint(
                "getMostRecentPostImageUrl : Found image URL: $imageUrl");
            return imageUrl;
          } else {
            debugPrint(
                "getMostRecentPostImageUrl : Referenced post document does not exist.");
          }
        } else {
          debugPrint("getMostRecentPostImageUrl : Post reference is null.");
        }
      } else {
        debugPrint(
            "getMostRecentPostImageUrl : No posts found in the collection's feed.");
      }
    } catch (e) {
      // Print any exceptions that occur
      debugPrint(
          "getMostRecentPostImageUrl : An error occurred while fetching the post image URL: $e");
    }
    // Return a default image URL if no image is found or an error occurs
    return 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';
  }

  Future<void> _showBottomSheetCollection(
      BuildContext context, MyCollectionState state) async {
    final Size size = MediaQuery.of(context).size;

    int? result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajoutez cette ligne
            children: [
              _buildTopRow(context, size),
              buildListView(
                scrollController,
                state,
                _imageUrls,
                widget.postId,
                _postInCollectionMap,
              ),
            ],
          ),
        ),
      ),
    );

    // ignore: avoid_print
    print(result);
  }

  Future<void> _fetchImageUrls(List<Collection> collections) async {
    // Fetch all image URLs
    List<String> urls = [];
    for (var collection in collections) {
      String imageUrl = await getMostRecentPostImageUrl(collection.id);
      urls.add(imageUrl);
    }

    // Check if the state is still mounted before updating
    if (mounted) {
      setState(() {
        _imageUrls = urls;
      });
    }
  }

  Future<void> _loadPost() async {
    try {
      final post =
          await context.read<PostRepository>().getPostById(widget.postId);
      if (post != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection(Paths.users)
            .doc(post.author.id)
            .get();
        if (userDoc.exists) {
          setState(() {
            _post = post;
            _user = User.fromDocument(userDoc);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Column _buildTextColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enregistré dans mes Likes',
          style: AppTextStyles.titleHeadlineMidBlackBold(context),
        ),
        Text(
          'Privé',
          style: AppTextStyles.subtitleLargeGrey(context),
        ),
      ],
    );
  }

  Widget _buildTopRow(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 7),
      child: Column(
        children: [
          Row(
            children: [
              buildImageContainer(size, _post!),
              const SizedBox(width: 14),
              _buildTextColumn(context),
              const Spacer(),
              buildBookmarkIcon(context, widget.postId),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            child: buildCreatenewcollection(context, openCreateCollectionSheet),
          ),
        ],
      ),
    );
  }

  void openCreateCollectionSheet(BuildContext context) {
    final createCollectionCubit = context.read<CreateCollectionCubit>();

    showModalBottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return BlocProvider.value(
          value: createCollectionCubit,
          child: BlocConsumer<CreateCollectionCubit, CreateCollectionState>(
            listener: (context, state) {
              if (state.status == CreateCollectionStatus.success) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('newcollection'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    buildCaptionInput(context, _collectionNameController),
                    ValueListenableBuilder<bool>(
                      valueListenable: isPublicNotifier,
                      builder: (context, isPublic, _) {
                        return buildPublicButton(
                            context, isPublic, isPublicNotifier);
                      },
                    ),
                    const SizedBox(height: 18),
                    buildValidateButton(
                      context,
                      _collectionNameController,
                      isPublicNotifier,
                      widget.postId,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _addToLikesThenShowCollections(MyCollectionState state) async {
    final authState = context.read<AuthBloc>().state;
    final _userId = authState.user?.uid;

    if (_userId != null) {
      // Vérifier si le post est déjà dans les likes
      final isPostLiked = await context
          .read<PostRepository>()
          .isPostInLikes(postId: widget.postId, userId: _userId);

      if (isPostLiked) {
        _showBottomSheetCollection(context, state);
      } else {
        // Ajouter le post aux likes
        context
            .read<AddPostToLikesCubit>()
            .addPostToLikes(widget.postId, _userId);
        // Puis afficher le bottom sheet
        _showBottomSheetCollection(context, state);
      }
    } else {
      debugPrint('User ID is null');
    }
  }

  void _checkIfUserIsAuthor(String userId) async {
    try {
      DocumentSnapshot postDoc = await FirebaseFirestore.instance
          .collection(Paths.posts)
          .doc(widget.postId)
          .get();

      if (postDoc.exists) {
        var data = postDoc.data() as Map<String, dynamic>;
        DocumentReference authorRef = data['author'];
        if (authorRef.id == userId) {
          setState(() {
            _isUserTheAuthor = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération du post: $e');
    }
  }

  void _navigateToUserScreen(BuildContext context, User user) {
    context.push('/user/${user.id}');
  }

  void _navigateToCommentScreen(BuildContext context) {
    context.push('/post/${widget.postId}/comment');
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            if (_isUserTheAuthor)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  final postCubit = context.read<DeletePostsCubit>();
                  postCubit.deletePosts(widget.postId);
                  if (widget.fromPath.contains("/calendar")) {
                    GoRouter.of(context).go('/calendar');
                  } else {
                    GoRouter.of(context).go('/profile');
                  }
                },
              ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
