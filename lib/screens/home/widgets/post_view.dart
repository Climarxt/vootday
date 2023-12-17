import 'dart:ui';

import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/add_post_to_likes/add_post_to_likes_cubit.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/mycollection/mycollection_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostView extends StatefulWidget {
  final Post post;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  PostView({
    Key? key,
    required this.post,
    required this.isLiked,
    required this.onLike,
    this.recentlyLiked = false,
  }) : super(key: key ?? ValueKey(post.id));

  @override
  // ignore: library_private_types_in_public_api
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView>
    with SingleTickerProviderStateMixin {
  bool isImageVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          isImageVisible = true;
        });
      }
    });

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
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isImageVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: isImageVisible
          ? GestureDetector(
              onTap: () => _navigateToPostScreen(context),
              child: _buildPost(context),
            )
          : Container(color: white),
    );
  }

  Widget _buildPost(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: double.infinity,
      child: Stack(
        children: [
          _buildImage(widget.post.imageProvider),
          buildText(context),
        ],
      ),
    );
  }

  Widget _buildImage(CachedNetworkImageProvider imageUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildText(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 32,
          right: -1,
          child: Container(
            width: 74,
            height: 24,
            decoration: const BoxDecoration(
              color: couleurBleuClair2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Center(child: buildLikeCount(context)),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 12,
          child: buildUsername(context),
        ),
        Positioned(
          bottom: 6,
          right: 10,
          child: widget.post.id != null
              ? buildFavoriteButton(
                  context,
                  widget.post.id!,
                  _animation,
                  _controller,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget buildFavoriteButton(BuildContext context, String postId,
      Animation<double> animation, AnimationController controller) {
    return BlocBuilder<AddPostToLikesCubit, AddPostToLikesState>(
      builder: (context, state) {
        final cubit = context.read<AddPostToLikesCubit>();
        final authState = context.read<AuthBloc>().state;
        final userId = authState.user?.uid;

        return FutureBuilder<bool>(
          future: cubit.isPostLiked(postId, userId!),
          builder: (context, snapshot) {
            bool isLiked = snapshot.data ?? false;

            return ScaleTransition(
              scale: animation,
              child: GestureDetector(
                onTap: () async {
                  controller.forward(from: 0.0);
                  if (isLiked) {
                    await cubit.deletePostRefFromLikes(
                        postId: postId, userId: userId);
                  } else {
                    await cubit.addPostToLikes(postId, userId);
                  }
                },
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: white,
                    size: 30,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildUsername(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
            '/user/${widget.post.author.id}?username=${widget.post.author.username}');
      },
      child: Row(
        children: [
          UserProfileImage(
            radius: 27,
            outerCircleRadius: 28,
            profileImageUrl: widget.post.author.profileImageUrl,
          ),
          const SizedBox(width: 12),
          Text(
            widget.post.author.username,
            style: AppTextStyles.titlePost(context),
          ),
        ],
      ),
    );
  }

  Widget buildLikeCount(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${widget.recentlyLiked ? widget.post.likes + 1 : widget.post.likes}',
          style: AppTextStyles.titlePost(context),
        ),
        const SizedBox(width: 2),
        const Icon(
          Icons.emoji_events,
          color: white,
          size: 14,
        ),
      ],
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final username = widget.post.author.username;
    GoRouter.of(context).push('/post/${widget.post.id}?username=$username');
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
      setState(() {});
    }
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
}
