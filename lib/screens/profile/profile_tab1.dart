import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/widgets/cards/mosaique_profile_card.dart';
import 'package:flutter/material.dart';

class ProfileTab1 extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;
  const ProfileTab1({super.key, required this.state, required this.context});

  @override
  State<ProfileTab1> createState() => _ProfileTab1State();
}

class _ProfileTab1State extends State<ProfileTab1> {
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

        // Wrap the MosaiqueProfileCard with a white Container and AnimatedOpacity
        return Container(
          color: Colors.white, // White container before the image appears
          child: MosaiqueProfileCard(
            imageUrl: post!.thumbnailUrl,
          ),
        );
      },
    ),
  );
}
