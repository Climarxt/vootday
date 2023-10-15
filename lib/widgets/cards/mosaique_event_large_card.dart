import 'package:flutter/material.dart';

class MosaiqueEventLargeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const MosaiqueEventLargeCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardWidth = size.width * 0.6;
    return GestureDetector(
      child: SizedBox(
        width: cardWidth,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              _buildPost(imageUrl),
              /*
              Positioned(
                top: 5,
                right: -1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                          image: AssetImage("assets/icons/bookmark_horiz.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    /*
                    const FaIcon(
                      FontAwesomeIcons.solidBookmark,
                      color: couleurBleuClair2,
                      size: 50,
                    ),
                    */
                    Center(
                      child: Text(
                        '#17',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPost(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
