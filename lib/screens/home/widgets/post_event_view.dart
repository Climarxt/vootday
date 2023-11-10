import 'dart:ui';

import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class PostEventView extends StatefulWidget {
  final Post post;
  final String eventId;
  final String title;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  PostEventView({
    Key? key,
    required this.post,
    required this.title,
    required this.eventId,
    required this.isLiked,
    required this.onLike,
    this.recentlyLiked = false,
  }) : super(key: key ?? ValueKey(post.id));

  @override
  _PostEventViewState createState() => _PostEventViewState();
}

class _PostEventViewState extends State<PostEventView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

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
              image: widget.post.imageProvider,
            ),
          ),
          child: buildBody(context),
        ),
      ),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final String encodedUsername =
        Uri.encodeComponent(widget.post.author.username);
    final String encodedTitle = Uri.encodeComponent(widget.title);

    GoRouter.of(context).go(
      '/home/event/${widget.eventId}/post/${widget.post.id}'
      '?username=$encodedUsername'
      '&title=$encodedTitle',
    );
  }

  void _navigateToUserScreen(BuildContext context) {
    GoRouter.of(context).go(
      '/home/event/${widget.eventId}/user/${widget.post.author.id}'
      '?username=${Uri.encodeComponent(widget.post.author.username)}'
      '&title=${Uri.encodeComponent(widget.title)}',
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
}
