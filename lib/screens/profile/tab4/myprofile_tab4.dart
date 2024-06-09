import 'package:bootdv2/screens/profile/bloc/feed_mylikes/feed_mylikes_bloc.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileTab4 extends StatefulWidget {
  const MyProfileTab4({
    super.key,
  });

  @override
  State<MyProfileTab4> createState() => _MyProfileTab4State();
}

class _MyProfileTab4State extends State<MyProfileTab4>
    with AutomaticKeepAliveClientMixin<MyProfileTab4> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<FeedMyLikesBloc>().add(FeedMyLikesFetchPosts());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<FeedMyLikesBloc, FeedMyLikesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state, context),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildBody(FeedMyLikesState state, BuildContext context) {
  return RefreshIndicator(
    onRefresh: () async {
      context.read<FeedMyLikesBloc>().add(FeedMyLikesFetchPosts());
    },
    child: _buildGridView(state),
  );
}

Widget _buildGridView(FeedMyLikesState state) {
  return Container(
    color: Colors.white,
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      physics: const AlwaysScrollableScrollPhysics(), // Enable always scrollable physics
      cacheExtent: 10000,
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        final post = state.posts[index];
        if (post != null) {
          return MosaiqueMyProfileCard(post: post);
        } else {
          return const SizedBox.shrink();
        }
      },
    ),
  );
}
