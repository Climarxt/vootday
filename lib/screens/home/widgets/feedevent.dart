import 'package:bootdv2/widgets/cards/mosaique_event_long_card.dart';
import 'package:flutter/material.dart';

class FeedCalendar extends StatefulWidget {
  const FeedCalendar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FeedCalendarState createState() => _FeedCalendarState();
}

class _FeedCalendarState extends State<FeedCalendar> {
  List<String> imageList = [
    'assets/images/ITG1_2.jpg',
    'assets/images/ITG1_1.jpg',
    'assets/images/postImage.jpg',
    'assets/images/postImage2.jpg',
    'assets/images/9.jpg',
    'assets/images/10.jpg',
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
