import 'package:bootdv2/widgets/cards/mosaique_calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        final goRouter = GoRouter.of(context);
        goRouter.go('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 62,
          title: Text("Calendar",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              final goRouter = GoRouter.of(context);
              goRouter.go('/home');
            },
          ),
        ),
        body: ListView(
          children: [
            buildSectionTitle('This Week'),
            buildListview(),
            buildSectionTitle('Coming Soon'),
            buildListview(),
            buildSectionTitle('Past Event'),
            buildListview(),
          ],
        ),
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

  Widget buildListview() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 196,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _buildCard(context, imageList[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String imageUrl) {
    return MosaiqueCalendarCard(
      imageUrl: imageUrl,
      title: 'Titre Event',
      description: 'Description',
    );
  }
}
