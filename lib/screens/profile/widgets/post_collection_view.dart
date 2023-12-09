import 'dart:ui';

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostCollectionView extends StatefulWidget {
  final Post post;
  final String collectionId;
  final String title;

  PostCollectionView({
    Key? key,
    required this.post,
    required this.title,
    required this.collectionId,
  }) : super(key: key ?? ValueKey(post.id));

  @override
  _PostCollectionViewState createState() => _PostCollectionViewState();
}

class _PostCollectionViewState extends State<PostCollectionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
        onTap: () => _navigateToPostScreen(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: Stack(
                children: [
                  ImageLoaderPostEvent(
                    imageProvider: widget.post.imageProvider,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.5,
                  ),
                  buildBody(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final String encodedUsername =
        Uri.encodeComponent(widget.post.author.username);
    final String encodedTitle = Uri.encodeComponent(widget.title);

    GoRouter.of(context)
        .push('/home/event/${widget.collectionId}/post/${widget.post.id}'
            '?username=$encodedUsername'
            '&title=$encodedTitle');
  }

  void _navigateToUserScreen(BuildContext context) {
    GoRouter.of(context)
        .push('/home/event/${widget.collectionId}/user/${widget.post.author.id}'
            '?username=${Uri.encodeComponent(widget.post.author.username)}'
            '&title=${Uri.encodeComponent(widget.title)}');
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

  Column buildTitle(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _navigateToUserScreen(context),
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
                      profileImageUrl: widget.post.author.profileImageUrl,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.post.author.username,
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
}
