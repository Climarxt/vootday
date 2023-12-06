import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/screens/explorer/bloc/explorer_bloc.dart';
import 'package:bootdv2/screens/explorer/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorerScreen extends StatefulWidget {
  ExplorerScreen({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen>
    with AutomaticKeepAliveClientMixin<ExplorerScreen> {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<ExplorerBloc>().add(ExplorerFetchPosts());
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isFetching &&
        context.read<ExplorerBloc>().state.status !=
            ExplorerStatus.paginating) {
      _isFetching = true;
      context.read<ExplorerBloc>().add(ExplorerPaginatePosts());
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
    return BlocConsumer<ExplorerBloc, ExplorerState>(
      listener: (context, state) {
        if (state.status == ExplorerStatus.initial && state.posts.isEmpty) {
          context.read<ExplorerBloc>().add(ExplorerFetchPosts());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ExplorerState state) {
    switch (state.status) {
      case ExplorerStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                context.read<ExplorerBloc>().add(ExplorerFetchPosts());
                context.read<LikedPostsCubit>().clearAllLikedPosts();
              },
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 0.5,
                ),
                physics: const BouncingScrollPhysics(),
                cacheExtent: 10000,
                controller: _scrollController,
                itemCount: state.posts.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == state.posts.length) {
                    return state.status == ExplorerStatus.paginating
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
            if (state.status == ExplorerStatus.paginating)
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
