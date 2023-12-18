import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:flutter/material.dart';

class MyProfileTab1 extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;

  const MyProfileTab1({
    super.key,
    required this.state,
    required this.context,
  });

  @override
  State<MyProfileTab1> createState() => _MyProfileTab1State();
}

class _MyProfileTab1State extends State<MyProfileTab1> {
  @override
  Widget build(BuildContext context) {
    return _buildGridView(widget.context, widget.state);
  }
}

Widget _buildGridView(BuildContext context, ProfileState state) {
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
      physics: const ClampingScrollPhysics(),
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
