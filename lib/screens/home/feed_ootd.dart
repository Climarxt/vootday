import 'package:bootdv2/models/post_model.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedOOTD extends StatefulWidget {
  FeedOOTD({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _FeedOOTDState createState() => _FeedOOTDState();
}

class _FeedOOTDState extends State<FeedOOTD>
    with AutomaticKeepAliveClientMixin<FeedOOTD> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
      listener: (context, state) {
        if (state.status == FeedOOTDStatus.initial && state.posts.isEmpty) {
          context.read<FeedOOTDBloc>().add(FeedOOTDFetchPostsOOTD());
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Scaffold(
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  Widget _buildBody(FeedOOTDState state) {
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
        if (state.status == FeedOOTDStatus.paginating)
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
