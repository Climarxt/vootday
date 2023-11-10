// ignore_for_file: avoid_print

import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/screens/home/bloc/feed_event/feed_event_bloc.dart';
import 'package:bootdv2/screens/home/widgets/post_event_view.dart';
import 'package:bootdv2/widgets/appbar/appbar_title_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedEvent extends StatefulWidget {
  final String eventId;
  final String title;
  final String logoUrl;
  FeedEvent({
    Key? key,
    required this.eventId,
    required this.title,
    required this.logoUrl,
  }) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _FeedEventState createState() => _FeedEventState();
}

class _FeedEventState extends State<FeedEvent>
    with AutomaticKeepAliveClientMixin<FeedEvent> {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context
        .read<FeedEventBloc>()
        .add(FeedEventFetchPostsEvent(eventId: widget.eventId));
    context
        .read<FeedEventBloc>()
        .add(FeedEventFetchEventDetails(eventId: widget.eventId));
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isFetching &&
        context.read<FeedEventBloc>().state.status !=
            FeedEventStatus.paginating) {
      _isFetching = true;
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
    return BlocConsumer<FeedEventBloc, FeedEventState>(
      listener: (context, state) {
        if (state.status == FeedEventStatus.initial && state.posts.isEmpty) {
          context
              .read<FeedEventBloc>()
              .add(FeedEventFetchPostsEvent(eventId: widget.eventId));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarTitleLogo(title: widget.title, logoUrl: widget.logoUrl),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FeedEventState state) {
    switch (state.status) {
      case FeedEventStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            ListView.separated(
              key: PageStorageKey<String>('feed-event-list-${widget.eventId}'),
              physics: const BouncingScrollPhysics(),
              cacheExtent: 10000,
              controller: _scrollController,
              itemCount: state.posts.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                if (index == state.posts.length) {
                  return state.status == FeedEventStatus.paginating
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                } else {
                  final post = state.posts[index];
                  final likedPostsState =
                      context.watch<LikedPostsCubit>().state;
                  final isLiked =
                      likedPostsState.likedPostIds.contains(post!.id);
                  final recentlyLiked =
                      likedPostsState.recentlyLikedPostIds.contains(post.id);
                  return PostEventView(
                    logoUrl: widget.logoUrl,
                    title: widget.title,
                    eventId: widget.eventId,
                    post: post,
                    isLiked: isLiked,
                    recentlyLiked: recentlyLiked,
                    onLike: () {
                      if (isLiked) {
                        context.read<LikedPostsCubit>().unlikePost(post: post);
                      } else {
                        context.read<LikedPostsCubit>().likePost(post: post);
                      }
                    },
                  );
                }
              },
            ),
            if (state.status == FeedEventStatus.paginating)
              const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
    }
  }

// Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
