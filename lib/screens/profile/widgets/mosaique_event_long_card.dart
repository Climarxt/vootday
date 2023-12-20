import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';

class MosaiqueEventLongCard extends StatefulWidget {
  final String imageUrl;
  final String logoUrl;
  final String title;
  final String eventId;

  const MosaiqueEventLongCard({
    super.key,
    required this.imageUrl,
    required this.logoUrl,
    required this.title,
    required this.eventId,
  });

  @override
  State<MosaiqueEventLongCard> createState() => _MosaiqueEventLongCardState();
}

class _MosaiqueEventLongCardState extends State<MosaiqueEventLongCard>
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
          ? Bounceable(
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
        Positioned(
          bottom: 3,
          left: 3,
          right: 0,
          child: buildTitle(context, title),
        ),
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withOpacity(1),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTitle(BuildContext context, String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            EventLogoImage(
              radius: 22.0,
              outerCircleRadius: 23,
              profileImageUrl: widget.logoUrl,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyles.titlePost(context),
            ),
          ],
        ),
      ),
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
