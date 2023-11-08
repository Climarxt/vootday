import 'dart:ui';

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/widgets/event_profile_image.dart';
import 'package:flutter/material.dart';

class MosaiqueEventLongCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const MosaiqueEventLongCard(
    BuildContext context, {
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, imageUrl, title, description);
  }

Widget _buildCard(
  BuildContext context, String imageUrl, String title, String description) {
  Size size = MediaQuery.of(context).size;
  return GestureDetector(
    child: SizedBox(
      height: size.height * 0.6,
      width: size.width,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            _buildPost(imageUrl),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Center(
                child: buildTitle(context),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildPost(String imageUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Column buildTitle(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const EventProfileImage(
                      radius: 22.0,
                      outerCircleRadius: 23,
                      profileImageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fthumbnails%2F1692461647733.jpg?alt=media&token=7ba67ead-3404-4d58-987a-f9caa156c4d3',
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'username',
                      style: AppTextStyles.titlePost(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
