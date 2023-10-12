import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/widgets/cards/mosaique_event_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedEvent extends StatefulWidget {
  const FeedEvent({super.key});

  @override
  _FeedEventState createState() => _FeedEventState();
}

class _FeedEventState extends State<FeedEvent> {
  List<String> imageList = [
    'assets/images/postImage.jpg',
    'assets/images/postImage2.jpg',
    'assets/images/ITG1_1.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/ITG3_1.jpg',
    'assets/images/ITG3_2.jpg',
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
          return _buildCard(context, imageList[index]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => GoRouter.of(context).go('/home/calendar'),
        label: Text('Calendar',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: white)),
        backgroundColor: couleurBleuClair2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCard(BuildContext context, String imageUrl) {
    return MosaiqueEventCard(
      imageUrl: imageUrl,
      title: 'Titre Event',
      description: 'Description',
    );
  }
}
