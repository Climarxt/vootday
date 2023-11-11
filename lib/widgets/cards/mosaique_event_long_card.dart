import 'dart:ui';

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/widgets/event_logo_image.dart';
import 'package:flutter/material.dart';
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
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
        onTap: () => _navigateToEventFeed(context),
        child: Stack(
          children: [
            _buildCard(context, widget.imageUrl, widget.title, widget.logoUrl),
          ],
        ),
      ),
    );
  }

  void _navigateToEventFeed(BuildContext context) {
    final encodedTitle = Uri.encodeComponent(widget.title);
    final encodedLogoUrl = Uri.encodeComponent(widget.logoUrl);

    GoRouter.of(context).push(
      '/home/event/${widget.eventId}?title=$encodedTitle&logoUrl=$encodedLogoUrl',
    );
  }

  Widget _buildCard(
      BuildContext context, String imageUrl, String title, String logoUrl) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            children: [
              _buildPost(imageUrl),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Center(
                  child: buildTitle(context, title),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost(String imageUrl) {
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

  Column buildTitle(BuildContext context, String title) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
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
            ),
          ),
        ),
      ],
    );
  }
}
