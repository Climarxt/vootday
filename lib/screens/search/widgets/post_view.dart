import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/add_post_to_likes/add_post_to_likes_cubit.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';

class PostView extends StatefulWidget {
  final Post post;

  PostView({
    Key? key,
    required this.post,
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
          ? Bounceable(
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
                  color: Colors.transparent,
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
      onTap: () => _navigateToUserScreen(context),
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
          '${widget.post.likes}',
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

  void _navigateToUserScreen(BuildContext context) {
    GoRouter.of(context).push(
        '/user/${widget.post.author.id}?username=${widget.post.author.username}');
    ;
  }
}
