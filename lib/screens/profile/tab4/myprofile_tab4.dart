import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:flutter/material.dart';

class MyProfileTab4 extends StatefulWidget {
  const MyProfileTab4({super.key});

  @override
  State<MyProfileTab4> createState() => _MyProfileTab4State();
}

class _MyProfileTab4State extends State<MyProfileTab4> {
  List<String> imageList = [
    'assets/images/postImage2.jpg',
    'assets/images/postImage.jpg',
    'assets/images/ITG3_2.jpg',
    'assets/images/ITG3_1.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/ITG1_1.jpg',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.8,
        ),
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return MosaiqueLikeCard(
            context,
            imageUrl: imageList[index],
          );
        },
      ),
    );
  }
}
