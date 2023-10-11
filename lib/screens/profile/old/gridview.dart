import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersistentGridView extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;

  const PersistentGridView(
      {super.key, required this.context, required this.state});

  @override
  // ignore: library_private_types_in_public_api
  _PersistentGridViewState createState() => _PersistentGridViewState();
}

class _PersistentGridViewState extends State<PersistentGridView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildGridView(widget.context, widget.state);
  }

  Widget _buildGridView(BuildContext context, ProfileState state) {
    return GridView.builder(
      padding: const EdgeInsets.all(2.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final post = state.posts[index];
        return GestureDetector(
          onTap: () {},
          child: CachedNetworkImage(
            fadeInDuration: const Duration(microseconds: 0),
            fadeOutDuration: const Duration(microseconds: 0),
            imageUrl: post!.thumbnailUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      },
      itemCount: state.posts.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
    );
  }
}
