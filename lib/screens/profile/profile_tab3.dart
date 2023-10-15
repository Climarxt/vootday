import 'package:bootdv2/widgets/cards/mosaique_collection_card.dart';
import 'package:flutter/material.dart';

class ProfileTab3 extends StatefulWidget {
  const ProfileTab3({super.key});

  @override
  State<ProfileTab3> createState() => _ProfileTab3State();
}

class _ProfileTab3State extends State<ProfileTab3> {
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
        return MosaiqueCollectionCard(
          context,
          title: "Titre",
          imageUrl: imageList[index],
        );
      },
    );
  }
}
