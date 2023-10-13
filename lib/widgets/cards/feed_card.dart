import 'package:bootdv2/widgets/profileimagebasique.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  final Size size;
  final String username;
  final String profileUrl;
  final String imageUrl;

  const FeedCard({
    Key? key,
    required this.size,
    required this.username,
    required this.profileUrl,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: widget.size.height * 0.6,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              _buildPost(),
              Align(
                alignment: Alignment.topLeft,
                child: ProfileImageFeed(
                  username: widget.username,
                  profileUrl: widget.profileUrl,
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
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}