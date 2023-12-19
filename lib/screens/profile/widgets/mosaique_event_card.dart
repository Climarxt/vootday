import 'package:bootdv2/config/configs.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MosaiqueEventCard extends StatefulWidget {
  final String imageUrl;
  final String logoUrl;
  final String title;
  final String eventId;

  const MosaiqueEventCard({
    super.key,
    required this.imageUrl,
    required this.logoUrl,
    required this.title,
    required this.eventId,
  });

  @override
  State<MosaiqueEventCard> createState() => _MosaiqueEventCardState();
}

class _MosaiqueEventCardState extends State<MosaiqueEventCard>
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
              onTap: () => _navigateToEventFeed(context),
              child: _buildPost(context, widget.imageUrl, widget.title),
            )
          : Container(color: white),
    );
  }

  Widget _buildPost(BuildContext context, String imageUrl, String title) {
    return Stack(
      children: [
        _buildImage(imageUrl),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToEventFeed(BuildContext context) {
    final encodedTitle = Uri.encodeComponent(widget.title);
    final encodedLogoUrl = Uri.encodeComponent(widget.logoUrl);

    GoRouter.of(context).push(
      '/feedevent/${widget.eventId}?title=$encodedTitle&logoUrl=$encodedLogoUrl',
    );
  }
}
