import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/following/bloc/following_bloc.dart';
import 'package:bootdv2/screens/following/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

class FollowingScreen extends StatefulWidget {
  FollowingScreen({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen>
    with AutomaticKeepAliveClientMixin<FollowingScreen> {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<FollowingBloc>().add(FollowingFetchPosts());
  }

  void _onScroll() {
    if (!mounted) return;

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isFetching &&
        context.read<FollowingBloc>().state.status !=
            FollowingStatus.paginating) {
      setState(() {
        _isFetching = true;
      });
      context.read<FollowingBloc>().add(FollowingPaginatePosts());
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
    return BlocConsumer<FollowingBloc, FollowingState>(
      listener: (context, state) {
        if (state.status == FollowingStatus.initial && state.posts.isEmpty) {
          context.read<FollowingBloc>().add(FollowingFetchPosts());
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

  Widget _buildBody(FollowingState state) {
    switch (state.status) {
      case FollowingStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                context.read<FollowingBloc>().add(FollowingFetchPosts());
              },
            ),
            _buildSliverGrid(state),
            if (state.status == FollowingStatus.paginating)
              const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
    }
  }

  Widget _buildSliverGrid(FollowingState state) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index >= state.posts.length) {
            return state.status == FollowingStatus.paginating
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          } else {
            final Post post = state.posts[index] ?? Post.empty;
            return PostView(post: post);
          }
        },
        childCount: state.posts.length + 1,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
