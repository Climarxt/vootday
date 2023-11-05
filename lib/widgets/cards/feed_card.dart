import 'package:bootdv2/widgets/profileimagebasique.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  final Size size;
  final String username;
  final String profileUrl;
  final String imageUrl;

  const FeedCard({
    super.key,
    required this.size,
    required this.username,
    required this.profileUrl,
    required this.imageUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: widget.size.height * 0.6,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(widget.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}
