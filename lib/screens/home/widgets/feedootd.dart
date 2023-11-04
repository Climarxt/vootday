// ignore_for_file: avoid_print

import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/screens/home/bloc/ootd/feed_ootd_bloc.dart';
import 'package:bootdv2/screens/home/widgets/post_view.dart';
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
        context.read<FeedOOTDBloc>().state.status !=
            FeedOOTDStatus.paginating) {
      _isFetching = true;
      context.read<FeedOOTDBloc>().add(FeedOOTDPaginatePosts());
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
    return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
      listener: (context, state) {
        if (state.status == FeedOOTDStatus.initial && state.posts.isEmpty) {
          context.read<FeedOOTDBloc>().add(FeedOOTDFetchPostsOOTD());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FeedOOTDState state) {
    switch (state.status) {
      case FeedOOTDStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              cacheExtent: 10000,
              controller: _scrollController,
              itemCount: state.posts.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                // Si l'index est égal à la longueur des éléments, affichez un CircularProgressIndicator
                // ou un SizedBox vide si la pagination n'est pas en cours
                if (index == state.posts.length) {
                  return state.status == FeedOOTDStatus.paginating
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
                  return PostView(
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
  }

// Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
