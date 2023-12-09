// ignore_for_file: avoid_print
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_bloc.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

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
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    final feedCollectionBloc = context.read<FeedCollectionBloc>();
    if (!feedCollectionBloc.state.hasFetchedInitialPosts ||
        feedCollectionBloc.state.collection?.id != widget.collectionId) {
      feedCollectionBloc.add(
          FeedCollectionFetchPostsCollections(collectionId: widget.collectionId));
    }
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isFetching &&
        context.read<FeedCollectionBloc>().state.status !=
            FeedCollectionStatus.paginating) {
      _isFetching = true;
      context.read<FeedCollectionBloc>().add(
          FeedCollectionPaginatePostsCollections(collectionId: widget.collectionId));
    }
  }

  @override
  void dispose() {
    _textController.dispose();
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
          appBar: AppBarTitle(title: widget.title),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FeedCollectionState state) {
    return Stack(
      children: [
        ListView.separated(
          key: PageStorageKey<String>('feed-event-list-${widget.collectionId}'),
          physics: const BouncingScrollPhysics(),
          cacheExtent: 10000,
          controller: _scrollController,
          itemCount: state.posts.length + 1,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
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

// Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
