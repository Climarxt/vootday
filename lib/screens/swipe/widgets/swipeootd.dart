import 'package:bootdv2/widgets/profileimagebasique.dart';
import 'package:flutter/material.dart';

bool _isLoading = false;

class SwipeOOTD extends StatelessWidget {
  const SwipeOOTD({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return _buildDefaultState(size);
  }

  Widget _buildDefaultState(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCard('assets/images/ITG1_1.jpg','assets/images/profile1.jpg', 'ct.bast'),
          const Divider(),
          _buildCard('assets/images/ITG1_2.jpg','assets/images/profile2.jpg', 'user.test'),
        ],
      ),
    );
  }

  Widget _buildCard(String imageUrl, String profileImage, String username) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: AspectRatio(
        aspectRatio: 1.17,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              _buildPost(imageUrl),
              Align(
                alignment: Alignment.topLeft,
                child: ProfileImageFeed(
                  username: username,
                  profileUrl: (profileImage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost(String imageUrl) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          );
  }

}