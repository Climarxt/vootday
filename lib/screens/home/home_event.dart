// ignore_for_file: avoid_print

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/screens/home/bloc/home_event/home_event_bloc.dart';
import 'package:bootdv2/screens/home/widgets/post_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeEvent extends StatefulWidget {
  HomeEvent({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _HomeEventState createState() => _HomeEventState();
}

class _HomeEventState extends State<HomeEvent>
    with AutomaticKeepAliveClientMixin<HomeEvent> {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isFetching &&
        context.read<HomeEventBloc>().state.status !=
            HomeEventStatus.paginating) {
      _isFetching = true;
      context.read<HomeEventBloc>().add(HomeEventPaginatePosts());
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
    return BlocConsumer<HomeEventBloc, HomeEventState>(
      listener: (context, state) {
        if (state.status == HomeEventStatus.initial && state.events.isEmpty) {
          context.read<HomeEventBloc>().add(HomeEventFetchPostsMonth());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(HomeEventState state) {
    switch (state.status) {
      case HomeEventStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              cacheExtent: 10000,
              controller: _scrollController,
              itemCount: state.events.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                if (index == state.events.length) {
                  return state.status == HomeEventStatus.paginating
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                } else {
                  final post = state.events[index];
                  final likedPostsState =
                      context.watch<LikedPostsCubit>().state;
                  final isLiked =
                      likedPostsState.likedPostIds.contains(post!.id);
                  final recentlyLiked =
                      likedPostsState.recentlyLikedPostIds.contains(post.id);
                  return Container(color: couleurJauneOrange);

                  /* PostView(
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
                  */
                }
              },
            ),
            if (state.status == HomeEventStatus.paginating)
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
