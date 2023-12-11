import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class EventNewCard extends StatefulWidget {
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
  State<EventNewCard> createState() => _EventNewCardState();
}

class _EventNewCardState extends State<EventNewCard> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _opacity = 1.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 300),
      child: _buildCard(
          context, widget.imageUrl, widget.title, widget.description),
    );
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
    final String encodedTitle = Uri.encodeComponent(widget.title);
    final String encodedLogoUrl = Uri.encodeComponent(widget.imageUrl);
    final String encodedAuthor = Uri.encodeComponent(widget.author);

    GoRouter.of(context).push(
      '/event/${widget.eventId}'
      '?title=$encodedTitle'
      '&logoUrl=$encodedLogoUrl'
      '&author=$encodedAuthor',
    );
  }

  Widget _buildPost(String imageUrl) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 700),
      child: SvgPicture.network(
        imageUrl,
        fit: BoxFit.fitHeight,
        alignment: Alignment.center,
      ),
    );
  }
}
