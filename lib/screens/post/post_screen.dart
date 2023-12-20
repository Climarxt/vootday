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

    context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());

    final authState = context.read<AuthBloc>().state;
    final _userId = authState.user?.uid;
    if (_userId != null) {
      _checkIfUserIsAuthor(_userId);
    } else {
      debugPrint('User ID is null');
    }

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
        final state = context.read<MyCollectionBloc>().state;
        final nonNullCollections = state.collections
            .where((collection) => collection != null)
            .cast<Collection>()
            .toList();
        _fetchImageUrls(nonNullCollections);

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

  Future<void> showBottomSheetCollection(
      BuildContext context,
      MyCollectionState state,
      Post post,
      void Function(BuildContext) openCreateCollectionSheet,
      List<String> imageUrls,
      Map<String, bool> postInCollectionMap) async {
    final Size size = MediaQuery.of(context).size;

    await showModalBottomSheet(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTopRow(context, size, post, openCreateCollectionSheet),
              buildListView(
                scrollController,
                state,
                imageUrls,
                post.id!,
                postInCollectionMap,
              ),
            ],
          ),
        ),
      ),
    );

    // Re-fetch image URLs after the bottom sheet is closed
    if (mounted) {
      final updatedCollections = state.collections
          .where((collection) => collection != null)
          .cast<Collection>()
          .toList();
      await _fetchImageUrls(updatedCollections);
    }
  }

  Future<void> _fetchImageUrls(List<Collection> collections) async {
    // Fetch all image URLs
    List<String> urls = [];
    for (var collection in collections) {
      String imageUrl = await getMostRecentPostImageUrl(collection.id);
      urls.add(imageUrl);
    }
    _imageUrls = urls;
  }

  Future<String> getMostRecentPostImageUrl(String collectionId) async {
    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection');

      final querySnapshot =
          await feedEventRef.orderBy('date', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        final DocumentReference? postRef =
            data['post_ref'] as DocumentReference?;

        if (postRef != null) {
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            final postData = postDoc.data() as Map<String, dynamic>?;
            debugPrint(
                "PostScreen - getMostRecentPostImageUrl : Referenced post document exist.");
            return postData?['imageUrl'] as String? ?? '';
          } else {
            debugPrint(
                "PostScreen - getMostRecentPostImageUrl : Referenced post document does not exist.");
          }
        } else {
          debugPrint(
              "PostScreen - getMostRecentPostImageUrl : Post reference is null.");
        }
      }
    } catch (e) {
      debugPrint(
          "PostScreen - getMostRecentPostImageUrl : An error occurred while fetching the most liked post image URL: $e");
    }
    return 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';
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
        showBottomSheetCollection(
          context,
          state,
          _post!,
          openCreateCollectionSheet,
          _imageUrls,
          _postInCollectionMap,
        );
      } else {
        // Ajouter le post aux likes
        context
            .read<AddPostToLikesCubit>()
            .addPostToLikes(widget.postId, _userId);
        // Puis afficher le bottom sheet
        showBottomSheetCollection(
          context,
          state,
          _post!,
          openCreateCollectionSheet,
          _imageUrls,
          _postInCollectionMap,
        );
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
    context.push('/post/${widget.postId}/comment?postId=${widget.postId}');
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
