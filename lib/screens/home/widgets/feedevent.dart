import 'package:bootdv2/widgets/cards/mosaique_event_long_card.dart';
import 'package:flutter/material.dart';

class FeedEvent extends StatefulWidget {
  const FeedEvent({super.key});

  @override
  _FeedEventState createState() => _FeedEventState();
}

class _FeedEventState extends State<FeedEvent> {
  List<String> imageList = [
    'assets/images/ITG1_2.jpg',
    'assets/images/Carhartt.png',
    'assets/images/Obey.png',
    'assets/images/postImage2.jpg',
    'assets/images/Sandro.png',
    'assets/images/Stussy.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.8,
        ),
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return MosaiqueEventLongCard(
            context,
            imageUrl: imageList[index],
            title: 'Title',
            description: 'Description',
          );
        },
      ),
    );
  }
}
