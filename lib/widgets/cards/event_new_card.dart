import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventNewCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const EventNewCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, imageUrl, title, description);
  }

  Widget _buildCard(
      BuildContext context, String imageUrl, String title, String description) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: SizedBox(
        width: size.width,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              _buildPost(imageUrl),
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.white),
                    ),
                    Text(description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost(String imageUrl) {
    return Stack(
      children: [
        SvgPicture.network(
          imageUrl,
          fit: BoxFit.fitHeight,
          alignment: Alignment.center,
        )
      ],
    );
  }
}
