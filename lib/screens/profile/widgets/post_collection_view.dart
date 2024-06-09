// ignore_for_file: library_private_types_in_public_api

import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final id = widget.post.author.id;
    GoRouter.of(context).push('/post/${widget.post.id}?userId=$id');
  }
}
