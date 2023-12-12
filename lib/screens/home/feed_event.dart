// ignore_for_file: avoid_print
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

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
  @override
  void initState() {
    super.initState();
    final feedEventBloc = context.read<FeedEventBloc>();
    if (!feedEventBloc.state.hasFetchedInitialPosts ||
        feedEventBloc.state.event?.id != widget.eventId) {
      feedEventBloc.add(FeedEventFetchPostsEvents(eventId: widget.eventId));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<FeedEventBloc, FeedEventState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Scaffold(
            appBar: AppBarTitleLogoOption(
                title: widget.title, logoUrl: widget.logoUrl),
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  Widget _buildBody(FeedEventState state) {
    return Stack(
      children: [
        ListView.separated(
          key: PageStorageKey<String>('feed-event-list-${widget.eventId}'),
          physics: const BouncingScrollPhysics(),
          cacheExtent: 10000,
          itemCount: state.posts.length + 1,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
          itemBuilder: (BuildContext context, int index) {
            if (index == state.posts.length) {
              return state.status == FeedEventStatus.paginating
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            } else {
              final post = state.posts[index] ?? Post.empty;
              return PostEventView(
                key: ValueKey('${widget.eventId}-${post.id}'),
                logoUrl: widget.logoUrl,
                title: widget.title,
                eventId: widget.eventId,
                post: post,
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

// Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
