import 'package:bootdv2/config/configs.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
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
              child: _buildPost(context, widget.imageUrl, widget.name),
            )
          : Container(color: white),
    );
  }

  Widget _buildPost(BuildContext context, String imageUrl, String title) {
    return Stack(
      children: [
        _buildImage(imageUrl),
        Positioned(
          bottom: 10,
          left: 1,
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
        child: Text(
          title,
          style: AppTextStyles.titlePost(context),
        ),
      ),
    );
  }

  void _navigateToEventFeed(BuildContext context) {
    final encodedName = Uri.encodeComponent(widget.name);

    GoRouter.of(context).push(
      '/collection/${widget.collectionId}?title=$encodedName',
    );
  }
}
