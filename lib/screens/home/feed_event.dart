// ignore_for_file: avoid_print, unrelated_type_equality_checks
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedEvent extends StatefulWidget {
  final String eventId;
  final String title;
  final String logoUrl;
  const FeedEvent({
    super.key,
    required this.eventId,
    required this.title,
    required this.logoUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FeedEventState createState() => _FeedEventState();
}

class _FeedEventState extends State<FeedEvent>
    with AutomaticKeepAliveClientMixin<FeedEvent> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FeedEventBloc, FeedEventState>(
      builder: (context, state) {
        final feedEventBloc = context.read<FeedEventBloc>();
        if (!feedEventBloc.state.hasFetchedInitialPosts ||
            feedEventBloc.state.posts.isEmpty) {
          feedEventBloc.add(FeedEventFetchPostsEvents(eventId: widget.eventId));
        }
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
          physics: const BouncingScrollPhysics(),
          cacheExtent: 10000,
          itemCount: state.posts.length + 1,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
          itemBuilder: (BuildContext context, int index) {
            if (index == state.posts.length) {
              return state.status == FeedMonthStatus.paginating
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            } else {
              final Post post = state.posts[index] ?? Post.empty;
              return PostView(
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

  @override
  bool get wantKeepAlive => true;
}
