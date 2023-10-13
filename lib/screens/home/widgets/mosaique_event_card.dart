import 'package:flutter/material.dart';

class MosaiqueEventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const MosaiqueEventCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl), // Assurez-vous que imageUrl est une URL valide
          ListTile(
            title: Text(title),
            subtitle: Text(description),
          ),
        ],
      ),
    );
  }
}
