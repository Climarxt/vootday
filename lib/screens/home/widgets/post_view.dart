import 'dart:ui';

import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/add_post_to_likes/add_post_to_likes_cubit.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/home/widgets/snackbar_util.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/feed_mylikes/feed_mylikes_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  String? userId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    userId = authState.user?.uid;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          isImageVisible = true;
        });
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
          bottom: 24,
          right: 20,
          child: buildLikeIcon(),
        ),
      ],
    );
  }

  Widget buildLikeIcon() {
    if (widget.post.id == null || userId == null) {
      return const Icon(Icons.bookmark_border, color: greyDark);
    }

    return FutureBuilder<bool>(
      future: context
          .read<PostRepository>()
          .isPostInLikes(postId: widget.post.id!, userId: userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          // Gérer l'erreur ou l'absence de données
          return const Icon(Icons.bookmark_border, color: greyDark);
        }

        final isPostLiked = snapshot.data!;

        return IconButton(
          icon: Icon(isPostLiked ? Icons.bookmark : Icons.bookmark_border,
              color: white),
          onPressed: () {
            if (isPostLiked) {
              context.read<FeedMyLikesBloc>().add(FeedMyLikesDeletePostRef(
                  postId: widget.post.id!, userId: userId!));
              SnackbarUtil.showSuccessSnackbar(
                  context, 'Post removed from Likes!');
            } else {
              context
                  .read<AddPostToLikesCubit>()
                  .addPostToLikes(widget.post.id!, userId!);
              SnackbarUtil.showSuccessSnackbar(context, 'Post Added to Likes!');
            }
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
}
