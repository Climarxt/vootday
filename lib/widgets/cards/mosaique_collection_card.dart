import 'package:flutter/material.dart';

class MosaiqueCollectionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  const MosaiqueCollectionCard(BuildContext context, {
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, imageUrl, title);
  }

  Widget _buildCard(BuildContext context, String imageUrl, String title) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: SizedBox(
        height: size.height * 0.6,
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
                bottom: 20,
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
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: const Alignment(0, 0.33),
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
