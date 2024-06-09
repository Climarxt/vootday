// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_field

import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/cubits/add_post_to_likes/add_post_to_likes_cubit.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/like/like_repository.dart';
import 'package:bootdv2/repositories/post/post_fetch_repository.dart';
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
  final String userId;
  final String fromPath;

  const PostScreen({
    super.key,
    required this.postId,
    required this.userId,
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
  late ContextualLogger logger;

  @override
  void initState() {
    logger = ContextualLogger('PostScreen');
    super.initState();
    _loadPost();

    context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());

    final authState = context.read<AuthBloc>().state;
    final userIdfromAuth = authState.user?.uid;
    if (userIdfromAuth != null) {
      _checkIfUserIsAuthor(userIdfromAuth, widget.postId);
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

        return Scaffold(
          appBar: AppBarTitle(title: _user!.username),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPostImage(size, _post!),
                  const SizedBox(height: 12),
                  buildPostDetails(
                    state,
                    context,
                    _user!,
                    _post!,
                    () => _navigateToUserScreen(context, _user!),
                    _showBottomSheet,
                    _showBottomSheetShare,
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
        initialChildSize: 0.8,
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
                post.author.id,
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
    const String functionName = 'getMostRecentPostImageUrl';
    try {
      logger.logInfo(functionName, 'Fetching most recent post image URL', {
        'collectionId': collectionId,
      });

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
            logger.logInfo(functionName, 'Referenced post document exists');
            return postData?['imageUrl'] as String? ?? '';
          } else {
            logger.logInfo(
                functionName, 'Referenced post document does not exist');
          }
        } else {
          logger.logInfo(functionName, 'Post reference is null');
        }
      }
    } catch (e) {
      logger.logError(
          functionName, 'Error fetching the most liked post image URL', {
        'error': e.toString(),
      });
    }
    return 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';
  }

  Future<void> _loadPost() async {
    try {
      final postId = widget.postId;
      final userId = widget.userId; // Récupérer userId à partir du widget
      final post =
          await context.read<PostFetchRepository>().getPostById(postId, userId);
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
    final TextEditingController _collectionNameController =
        TextEditingController();
    final FocusNode _focusNode = FocusNode();

    showModalBottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      context: context,
      isScrollControlled:
          true, // Allow the sheet to be scrollable and adjust its size
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
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('newcollection'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            buildCaptionInput(
                                context,
                                _collectionNameController,
                                _focusNode,
                                setState),
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
                              widget.userId,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _addToLikesThenShowCollections(MyCollectionState state) async {
    final authState = context.read<AuthBloc>().state;
    final userIdfromAuth = authState.user?.uid;

    if (userIdfromAuth != null) {
      // Vérifier si le post est déjà dans les likes
      final isPostLiked = await context.read<LikeRepository>().isPostInLikes(
          postId: widget.postId,
          userIdfromPost: widget.userId,
          userIdfromAuth: userIdfromAuth);

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
            .addPostToLikes(widget.postId, widget.userId, userIdfromAuth);
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

  void _checkIfUserIsAuthor(String userIdfromAuth, String postId) async {
    try {
      DocumentSnapshot postDoc = await FirebaseFirestore.instance
          .collection(Paths.users)
          .doc(userIdfromAuth)
          .collection(Paths.posts)
          .doc(postId)
          .get();

      if (postDoc.exists) {
        var data = postDoc.data() as Map<String, dynamic>;
        DocumentReference authorRef = data['author'];
        if (authorRef.id == userIdfromAuth) {
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
    context.push(
        '/post/${widget.postId}/comment?postId=${widget.postId}&userId=${widget.userId}');
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              if (_isUserTheAuthor)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    final postCubit = context.read<DeletePostsCubit>();
                    postCubit.deletePosts(widget.postId, widget.userId);
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
          ),
        );
      },
    );
  }

  void _showBottomSheetShare(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
