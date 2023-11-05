import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/models.dart';
import '/screens/screens.dart';
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
          borderRadius: BorderRadius.circular(20),
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
          child: buildScaffold(context),
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
    GoRouter.of(context).push('/home/${post.id}');
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: buildTitleColumn(context),
    );
  }

  Column buildTitleColumn(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            context.go('/profile/${post.author.id}');
          },
          child: UserProfileImage(
            radius: 22.0,
            outerCircleRadius: 23,
            profileImageUrl: post.author.profileImageUrl,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          post.author.username,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: white,
            shadows: [
              Shadow(offset: Offset(-0.2, -0.2), color: Colors.grey),
              Shadow(offset: Offset(0.2, -0.2), color: Colors.grey),
              Shadow(offset: Offset(0.2, 0.2), color: Colors.grey),
              Shadow(offset: Offset(-0.2, 0.2), color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Container buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [buildActionRow(context)],
      ),
    );
  }

  Row buildActionRow(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Column(
          children: [
            buildLikeButton(),
            buildLikeCount(),
            const SizedBox(width: 38),
            buildCommentButton(context),
          ],
        ),
      ],
    );
  }

  IconButton buildLikeButton() {
    return IconButton(
      icon: isLiked
          ? const Icon(Icons.favorite, color: Colors.red)
          : const Icon(Icons.favorite, color: white),
      onPressed: onLike,
    );
  }

  Text buildLikeCount() {
    return Text(
      '${recentlyLiked ? post.likes + 1 : post.likes}',
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: white,
        shadows: [
          Shadow(offset: Offset(-0.2, -0.2), color: Colors.grey),
          Shadow(offset: Offset(0.2, -0.2), color: Colors.grey),
          Shadow(offset: Offset(0.2, 0.2), color: Colors.grey),
          Shadow(offset: Offset(-0.2, 0.2), color: Colors.grey),
        ],
      ),
    );
  }

  IconButton buildCommentButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.comment_outlined,
        color: white,
      ),
      onPressed: () {},
    );
  }
}
