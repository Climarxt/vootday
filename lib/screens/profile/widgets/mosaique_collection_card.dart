import 'dart:ui';

import 'package:bootdv2/config/configs.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MosaiqueCollectionCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String collectionId;

  const MosaiqueCollectionCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.collectionId,
  });

  @override
  State<MosaiqueCollectionCard> createState() => _MosaiqueCollectionCardState();
}

class _MosaiqueCollectionCardState extends State<MosaiqueCollectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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
            _buildCard(context, widget.imageUrl, widget.name),
          ],
        ),
      ),
    );
  }

  void _navigateToEventFeed(BuildContext context) {
    final encodedName = Uri.encodeComponent(widget.name);

    GoRouter.of(context).push(
      '/profile/collection/${widget.collectionId}?title=$encodedName',
    );
  }

  Widget _buildCard(BuildContext context, String imageUrl, String title) {
    return GestureDetector(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
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

  Widget buildTitle(BuildContext context, String title) {
    return Stack(
      children: [
        // Ajout du conteneur avec dégradé
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
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: AppTextStyles.titlePost(context),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
