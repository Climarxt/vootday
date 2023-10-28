import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/screens/home/bloc/feed_bloc.dart';
import 'package:bootdv2/screens/home/widgets/post_view.dart';
import 'package:bootdv2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedMonth extends StatefulWidget {
  const FeedMonth({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FeedMonthState createState() => _FeedMonthState();
}

class _FeedMonthState extends State<FeedMonth>
    with AutomaticKeepAliveClientMixin<FeedMonth> {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(FeedFetchPostsMonth());
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FeedBloc>().state.status != FeedStatus.paginating) {
          context.read<FeedBloc>().add(FeedPaginatePosts());
        }
      });
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
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                context.read<FeedBloc>().add(FeedFetchPostsMonth());
                context.read<LikedPostsCubit>().clearAllLikedPosts();
              },
              child: ListView.separated(
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
                    return state.status == FeedStatus.paginating
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
                          context
                              .read<LikedPostsCubit>()
                              .unlikePost(post: post);
                        } else {
                          context.read<LikedPostsCubit>().likePost(post: post);
                        }
                      },
                    );
                  }
                },
              ),
            ),
            if (state.status == FeedStatus.paginating)
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

  @override
  bool get wantKeepAlive => true; // Overridden to retain the state
}
