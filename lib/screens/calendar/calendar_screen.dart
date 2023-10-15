import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/widgets/cards/event_new_card.dart';
import 'package:bootdv2/widgets/cards/mosaique_event_large_card.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<String> imageList = [
    'assets/images/Stussy.png',
    'assets/images/postImage2.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/Carhartt.png',
    'assets/images/Obey.png',
    'assets/images/Sandro.png',
  ];

  List<String> imageList1 = [
    'assets/images/Sandro.png',
    'assets/images/Carhartt.png',
    'assets/images/Stussy.png',
    'assets/images/postImage2.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/Obey.png',
  ];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 62,
        title: Text(AppLocalizations.of(context)!.translate('event'),
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(AppLocalizations.of(context)!.translate('new')),
          const Expanded(
            flex: 1,
            child: EventNewCard(
                imageUrl: "assets/images/Obey.png",
                title: "Title",
                description: "Description"),
          ),
          const SizedBox(height: 8),
          buildSectionTitle(
            AppLocalizations.of(context)!.translate('comingsoon'),
          ),
          buildListview(size),
          const SizedBox(height: 8),
          buildSectionTitle(
            AppLocalizations.of(context)!.translate('pastevents'),
          ),
          buildListview1(size),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 5.0, top: 5.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.black),
      ),
    );
  }

  Widget buildListview(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SizedBox(
        height: size.height * 0.2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: MosaiqueEventLargeCard(
                imageUrl: imageList[index],
                title: 'Title',
                description: 'Description',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildListview1(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SizedBox(
        height: size.height * 0.2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: MosaiqueEventLargeCard(
                imageUrl: imageList1[index],
                title: 'Title',
                description: 'Description',
              ),
            );
          },
        ),
      ),
    );
  }
}
