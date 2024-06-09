// ignore_for_file: avoid_print
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_bloc.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedCollection extends StatefulWidget {
  final String collectionId;
  final String title;
  FeedCollection({
    Key? key,
    required this.collectionId,
    required this.title,
  }) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _FeedCollectionState createState() => _FeedCollectionState();
}

class _FeedCollectionState extends State<FeedCollection>
    with AutomaticKeepAliveClientMixin<FeedCollection> {
  bool _isUserTheAuthor = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    final feedCollectionBloc = context.read<FeedCollectionBloc>();
    if (!feedCollectionBloc.state.hasFetchedInitialPosts ||
        feedCollectionBloc.state.collection?.id != widget.collectionId) {
      feedCollectionBloc.add(FeedCollectionFetchPostsCollections(
          collectionId: widget.collectionId));

      final authState = context.read<AuthBloc>().state;
      final userId = authState.user?.uid;

      if (userId != null) {
        _checkIfUserIsAuthor(userId);
      } else {
        print('User ID is null');
      }
    }
  }

  void _checkIfUserIsAuthor(String userId) async {
    try {
      DocumentSnapshot postDoc = await FirebaseFirestore.instance
          .collection(Paths.collections)
          .doc(widget.collectionId)
          .get();

      if (postDoc.exists) {
        var data = postDoc.data() as Map<String, dynamic>;
        DocumentReference authorRef = data['author'];
        if (authorRef.id == userId) {
          setState(() {
            _isUserTheAuthor = true;
          });
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération du post: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<FeedCollectionBloc, FeedCollectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarTitleOption(
              title: widget.title,
              collectionId: widget.collectionId,
              isUserTheAuthor: _isUserTheAuthor),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FeedCollectionState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: GridView.builder(
            key: PageStorageKey<String>(widget.collectionId),
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 0.5,
            ),
            physics: const BouncingScrollPhysics(),
            cacheExtent: 10000,
            itemCount: state.posts.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == state.posts.length) {
                return state.status == FeedCollectionStatus.paginating
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              } else {
                final post = state.posts[index] ?? Post.empty;
                return PostCollectionView(
                  key: ValueKey('${widget.collectionId}-${post.id}'),
                  title: widget.title,
                  collectionId: widget.collectionId,
                  post: post,
                );
              }
            },
          ),
        ),
        if (state.status == FeedCollectionStatus.paginating)
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
