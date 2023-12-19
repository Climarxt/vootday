import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostEventView extends StatefulWidget {
  final Post post;
  final String eventId;
  final String title;
  final String logoUrl;

  PostEventView({
    Key? key,
    required this.post,
    required this.title,
    required this.logoUrl,
    required this.eventId,
  }) : super(key: key ?? ValueKey(post.id));

  @override
  _PostEventViewState createState() => _PostEventViewState();
}

class _PostEventViewState extends State<PostEventView>
    with SingleTickerProviderStateMixin {
  bool isImageVisible = false;

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
      ],
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
    final String encodedUsername =
        Uri.encodeComponent(widget.post.author.username);
    final String encodedTitle = Uri.encodeComponent(widget.title);
    final String encodedLogoUrl = Uri.encodeComponent(widget.logoUrl);

    GoRouter.of(context).push(
      '/post/${widget.post.id}'
      '?username=$encodedUsername'
      '&title=$encodedTitle'
      '&logoUrl=$encodedLogoUrl',
    );
  }

  void _navigateToUserScreen(BuildContext context) {
    GoRouter.of(context).push(
      '/user/${widget.post.author.id}'
      '?username=${Uri.encodeComponent(widget.post.author.username)}'
      '&title=${Uri.encodeComponent(widget.title)}'
      '&logoUrl=${Uri.encodeComponent(widget.logoUrl)}',
    );
  }
}
