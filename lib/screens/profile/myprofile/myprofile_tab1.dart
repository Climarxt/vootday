import 'package:bootdv2/widgets/cards/mosaique_myprofile_card.dart';
import 'package:flutter/material.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';

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
    color: Colors.white, // Ensuring the background is white
    child: GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.8,
      ),
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        final post = state.posts[index];
        // Check if post is not null before creating the card
        if (post != null) {
          // Pass the entire post object to the MosaiqueProfileCard
          return MosaiqueMyProfileCard(post: post);
        } else {
          // If the post is null, return an empty placeholder widget
          return SizedBox.shrink();
        }
      },
    ),
  );
}