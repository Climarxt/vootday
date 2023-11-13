import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class EventNewCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String eventId;
  final String author;
  const EventNewCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.eventId,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, imageUrl, title, description);
  }

  Widget _buildCard(
      BuildContext context, String imageUrl, String title, String description) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => _navigateToEventScreen(context),
      child: SizedBox(
        width: size.width,
        child: Card(
          elevation: 2,
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

  void _navigateToEventScreen(BuildContext context) {
    final String encodedTitle = Uri.encodeComponent(title);
    final String encodedLogoUrl = Uri.encodeComponent(imageUrl);
    final String encodedAuthor = Uri.encodeComponent(author);

    GoRouter.of(context).push(
      '/calendar/event/$eventId'
      '?title=$encodedTitle'
      '&logoUrl=$encodedLogoUrl'
      '&author=$encodedAuthor',
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
