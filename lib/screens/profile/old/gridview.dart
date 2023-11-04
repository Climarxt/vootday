import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';

class PersistentGridView extends StatefulWidget {
  const PersistentGridView({super.key});

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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return _buildGridView(context, state);
      },
    );
  }

  Widget _buildGridView(BuildContext context, ProfileState state) {
    double width = MediaQuery.of(context).size.width;
    double imageDimension = (width - 2.0 * (2 - 1)) / 2;

    return GridView.builder(
      cacheExtent: 15000,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final post = state.posts[index];
        return GestureDetector(
          onTap: () {},
          child: CachedNetworkImage(
            imageUrl: post!.thumbnailUrl,
            cacheKey: post.id,
            fit: BoxFit.cover,
            memCacheHeight: (imageDimension * 3).round(),
            memCacheWidth: (imageDimension * 3).round(),
            filterQuality: FilterQuality.high,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
      },
      itemCount: state.posts.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }
}
