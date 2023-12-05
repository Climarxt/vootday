import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:flutter/material.dart';

class MyProfileTab3 extends StatefulWidget {
  const MyProfileTab3({super.key});

  @override
  State<MyProfileTab3> createState() => _MyProfileTab3State();
}

class _MyProfileTab3State extends State<MyProfileTab3> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: buildEditProfileButton(context),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          // Ajout du widget Expanded ici
          child: Container(
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
                return MosaiqueCollectionCard(
                  context,
                  title: "Titre",
                  imageUrl: imageList[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  TextButton buildEditProfileButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.add, color: black),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.translate('createnewcollection'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: black),
            ),
          ),
          Icon(Icons.arrow_forward, color: black),
        ],
      ),
    );
  }
}
