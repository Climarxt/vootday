import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/following/bloc/following_bloc.dart';
import 'package:bootdv2/screens/following/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                context.read<FollowingBloc>().add(FollowingFetchPosts());
              },
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                cacheExtent: 10000,
                controller: _scrollController,
                itemCount: state.posts.length + 1,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10),
                itemBuilder: (BuildContext context, int index) {
                  if (index == state.posts.length) {
                    return state.status == FollowingStatus.paginating
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  } else {
                    final Post? post = state.posts[index];

                    // Vérifier si post est null
                    if (post != null) {
                      return PostView(
                        post: post,
                      );
                    } else {
                      // Retourner un widget de remplacement ou rien si post est null
                      return const SizedBox.shrink();
                    }
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

  // Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
