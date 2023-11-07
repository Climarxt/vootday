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

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.transparent,
      body: buildBody(context),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final username = post.author.username;
    GoRouter.of(context).push('/home/post/${post.id}?username=$username');
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 24, right: 26.0),
          child: buildLikeCount(context),
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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
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

  Container buildBody(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            top: 33,
            right: -1,
            child: Container(
              width: 74,
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: couleurBleuClair2,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            top: 36,
            right: 24,
            child: buildLikeCount(context),
          ),
          Positioned(
            bottom: 10,
            left: 12,
            child: buildTitle(context),
          ),
        ],
      ),
    );
  }

  ClipRRect buildIconColumn(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.7),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildCommentButton(context),
                const SizedBox(height: 16),
                buildShareButton(context),
                const SizedBox(height: 16),
                buildSaveButton(context),
              ],
            )),
      ),
    );
  }

  IconButton buildSaveButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.add_to_photos,
        color: white,
      ),
      onPressed: () {},
    );
  }

  IconButton buildCommentButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.comment,
        color: white,
      ),
      onPressed: () {},
    );
  }

  IconButton buildShareButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.share,
        color: white,
      ),
      onPressed: () {},
    );
  }
}
