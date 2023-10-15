import 'package:bootdv2/widgets/cards/mosaique_profile_card.dart';
import 'package:flutter/material.dart';

class ProfileTab1 extends StatefulWidget {
  const ProfileTab1({super.key});

  @override
  State<ProfileTab1> createState() => _ProfileTab1State();
}

class _ProfileTab1State extends State<ProfileTab1> {
  List<String> imageList = [
    'assets/images/ITG1_1.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/ITG3_1.jpg',
    'assets/images/ITG3_2.jpg',
    'assets/images/postImage.jpg',
    'assets/images/postImage2.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return MosaiqueProfileCard(
          context,
          imageUrl: imageList[index],
        );
      },
    );
  }
}
