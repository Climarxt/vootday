import 'package:flutter/material.dart';

class EventNewCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const EventNewCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
  }) : super(key: key);

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
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.fitHeight,
              alignment: Alignment.center, // Center the image
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: const Alignment(0, 0.33),
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
