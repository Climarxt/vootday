import 'package:bootdv2/widgets/appbar/appbar_post.dart';
import 'package:bootdv2/widgets/profileimagepost.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  final String postImage;
  const EventScreen({
    super.key,
    required this.postImage,
  });

  @override
  State<EventScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/ITG1_1.jpg',
                      width: size.width,
                      fit: BoxFit.fitWidth,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18, right: 18),
                      child: Row(
                        children: [
                          ProfileImagePost(
                            title: 'Obey',
                            subtitle: 'Event #1',
                            profileUrl: 'assets/images/Obey.png',
                          ),
                          Spacer(),
                          Column(
                            children: [
                              SizedBox(height: 12),
                              Icon(Icons.more_vert,
                                  color: Colors.black, size: 24),
                              SizedBox(height: 32),
                              Icon(Icons.comment,
                                  color: Colors.black, size: 24),
                              SizedBox(height: 32),
                              Icon(Icons.share,
                                  color: Colors.black, size: 24),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Need Profile Bloc ButtonsSectionEvent(state: state),
                  ],
                ),
              ),
            ),

            // AppBar personnalisée
            const Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBarPost(),
            ),
          ],
        ),
      ),
    );
  }
}
