import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/screens/following/bloc/following_bloc.dart';
import 'package:bootdv2/screens/following/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FollowingBloc>().state.status !=
                FollowingStatus.paginating) {
          context.read<FollowingBloc>().add(FollowingPaginatePosts());
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
    return BlocConsumer<FollowingBloc, FollowingState>(
      listener: (context, state) {
        if (state.status == FollowingStatus.error) {
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

  Widget _buildBody(FollowingState state) {
    switch (state.status) {
      case FollowingStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                context.read<FollowingBloc>().add(FollowingFetchPosts());
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
                    return state.status == FollowingStatus.paginating
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
            if (state.status == FollowingStatus.paginating)
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

  List<Tab> tabs = [
    const Tab(
      child: Text(
        "BOOTD1",
        style: TextStyle(shadows: [
          Shadow(
              // bottomLeft
              offset: Offset(-0.1, -0.1),
              color: Colors.grey),
          Shadow(
              // bottomRight
              offset: Offset(0.1, -0.1),
              color: Colors.grey),
          Shadow(
              // topRight
              offset: Offset(0.1, 0.1),
              color: Colors.grey),
          Shadow(
              // topLeft
              offset: Offset(-0.1, 0.1),
              color: Colors.grey),
        ]),
      ),
    ),
    const Tab(
      child: Text(
        "BOOTD2",
        style: TextStyle(shadows: [
          Shadow(
              // bottomLeft
              offset: Offset(-0.1, -0.1),
              color: Colors.grey),
          Shadow(
              // bottomRight
              offset: Offset(0.1, -0.1),
              color: Colors.grey),
          Shadow(
              // topRight
              offset: Offset(0.1, 0.1),
              color: Colors.grey),
          Shadow(
              // topLeft
              offset: Offset(-0.1, 0.1),
              color: Colors.grey),
        ]),
      ),
    ),
    const Tab(
        child: Text(
      "BOOTD3",
      style: TextStyle(shadows: [
        Shadow(
            // bottomLeft
            offset: Offset(-0.1, -0.1),
            color: Colors.grey),
        Shadow(
            // bottomRight
            offset: Offset(0.1, -0.1),
            color: Colors.grey),
        Shadow(
            // topRight
            offset: Offset(0.1, 0.1),
            color: Colors.grey),
        Shadow(
            // topLeft
            offset: Offset(-0.1, 0.1),
            color: Colors.grey),
      ]),
    )),
  ];
  List<Widget> tabsContent = [
    Container(
      color: couleurBleu,
    ),
    Container(
      color: couleurBleu1,
    ),
    Container(
      color: couleurBleu2,
    ),
  ];
}
