import 'package:bootdv2/import/dummy.dart';
import 'package:bootdv2/widgets/cards/feed_card.dart';
import 'package:flutter/material.dart';

class FeedDay extends StatefulWidget {
  const FeedDay({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FeedDayState createState() => _FeedDayState();
}

class _FeedDayState extends State<FeedDay>
    with AutomaticKeepAliveClientMixin<FeedDay> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildTabContent(context);
  }

  Widget _buildTabContent(context) {
    final Size size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length + 1,
      itemBuilder: (context, index) => _buildItem(context, index, size),
    );
  }

  Widget _buildItem(BuildContext context, int index, Size size) {
    if (index < data.length) {
      return FeedCard(
        size: size,
        username: 'ct.bast',
        profileUrl: 'assets/images/profile2.jpg',
        imageUrl: 'assets/images/postImage.jpg',
      );
    }
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const SizedBox();
  }

  @override
  bool get wantKeepAlive => true; // Overridden to retain the state
}
