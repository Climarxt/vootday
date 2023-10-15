import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/import/dummy.dart';
import 'package:bootdv2/widgets/cards/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedDay extends StatefulWidget {
  const FeedDay({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FeedDayState createState() => _FeedDayState();
}

class _FeedDayState extends State<FeedDay>
    with AutomaticKeepAliveClientMixin<FeedDay> {
  List<String> imageList = [
    'assets/images/postImage2.jpg',
    'assets/images/ITG1_1.jpg',
    'assets/images/ITG3_2.jpg',
  ];
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildTabContent(context);
  }

  Widget _buildTabContent(context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length + 1,
        itemBuilder: (context, index) => _buildItem(context, index, size),
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
    );
  }

  Widget _buildItem(BuildContext context, int index, Size size) {
    if (index < data.length) {
      return FeedCard(
        size: size,
        username: 'ct.bast',
        profileUrl: 'assets/images/profile2.jpg',
        imageUrl: imageList[index %
            imageList
                .length], // Utiliser le modulo pour éviter les erreurs d'index
      );
    }
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const SizedBox();
  }

  @override
  bool get wantKeepAlive => true; // Overridden to retain the state
}
