import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/import/dummy.dart';
import 'package:bootdv2/screens/home/widgets/profileimagefeed.dart';
import 'package:flutter/material.dart';

bool _isLoading = false;

class FeedEvent extends StatelessWidget {
  const FeedEvent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: couleurJauneOrange);
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
      var item = data[index];
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: _buildCard(context, item, size),
      );
    }
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : const SizedBox();
  }

  Widget _buildCard(
      BuildContext context, Map<String, dynamic> item, Size size) {
    return GestureDetector(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              _buildPost(),
              const Align(
                alignment: Alignment.topLeft,
                child: ProfileImageFeed(
                  username: "ct.bast",
                  profileUrl: ('assets/images/profile1.jpg'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: const DecorationImage(
                image: AssetImage('assets/images/postImage2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}
