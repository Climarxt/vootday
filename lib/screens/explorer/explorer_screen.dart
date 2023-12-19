import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/models/models.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<ExplorerBloc>().add(ExplorerFetchPosts());
  }

  @override
  void dispose() {
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Scaffold(
            body: _buildBody(state),
          ),
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
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.5,
                ),
                physics: const BouncingScrollPhysics(),
                cacheExtent: 10000,
                itemCount: state.posts.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == state.posts.length) {
                    return state.status == ExplorerStatus.paginating
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
