import 'dart:ui';

import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class PostView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPostScreen(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: post.imageProvider,
            ),
          ),
          child: buildBody(context),
        ),
      ),
    );
  }

  Column buildTitle(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            context.go('/home/user/${post.author.id}');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    UserProfileImage(
                      radius: 22.0,
                      outerCircleRadius: 23,
                      profileImageUrl: post.author.profileImageUrl,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      post.author.username,
                      style: AppTextStyles.titlePost(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stack buildBody(BuildContext context) {
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
          child: buildTitle(context),
        ),
      ],
    );
  }

  Text buildLikeCount(BuildContext context) {
    return Text(
      '${recentlyLiked ? post.likes + 1 : post.likes}',
      style: AppTextStyles.titlePost(context),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final username = post.author.username;
    GoRouter.of(context).push('/home/post/${post.id}?username=$username');
  }
}
