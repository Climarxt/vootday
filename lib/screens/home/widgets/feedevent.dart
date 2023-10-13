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
          return MosaiqueEventCard(
            context,
            imageUrl: imageList[index],
            title: 'Title',
            description: 'Description',
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => GoRouter.of(context).go('/home/calendar'),
        label: Text(
          AppLocalizations.of(context)!.translate('calendar'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: white),
        ),
        backgroundColor: couleurBleuClair2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
