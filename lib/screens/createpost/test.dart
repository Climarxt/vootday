import 'package:bootdv2/cubits/brands/brands_cubit.dart';
import 'package:bootdv2/cubits/brands/brands_state.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/screens/home/bloc/feed_bloc.dart';
import 'package:bootdv2/screens/home/widgets/post_view.dart';
import 'package:bootdv2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(FeedFetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        debugPrint("Listener state: $state");
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        print("Current state: $state");
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
                context.read<FeedBloc>().add(FeedFetchPosts());
                context.read<LikedPostsCubit>().clearAllLikedPosts();
              },
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                cacheExtent: 10000,
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
}
