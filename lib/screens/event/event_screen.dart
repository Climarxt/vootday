import 'package:bootdv2/config/paths.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/post_repository.dart';
import 'package:bootdv2/screens/event/widgets/profile_image_event.dart';
import 'package:bootdv2/screens/post/widgets/image_loader.dart';
import 'package:bootdv2/widgets/appbar/appbar_title.dart';
import 'package:bootdv2/widgets/profileimagepost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EventScreen extends StatefulWidget {
  final String eventId;
  final String title;
  final String logoUrl;
  final String author;

  const EventScreen({
    super.key,
    required this.eventId,
    required this.title,
    required this.logoUrl,
    required this.author,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with AutomaticKeepAliveClientMixin {
  Event? _event;
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    try {
      final event =
          await context.read<PostRepository>().getEventById(widget.eventId);
      if (event != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection(Paths.events)
            .doc(event.id)
            .get();
        if (userDoc.exists) {
          setState(() {
            _event = event;
            _user = User.fromDocument(userDoc);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBarTitle(title: widget.title),
        body: const Center(
          child: Opacity(
            opacity: 0.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_event == null || _user == null) {
      return Scaffold(
        appBar: AppBarTitle(title: widget.title),
        body: const Center(child: Text('Post or user not found')),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBarTitle(title: widget.title),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageLoader(
                  imageProvider: _event!.imageProvider,
                  width: size.width,
                  height: size.height / 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      ProfileImageEvent(
                        title: widget.author,
                        likes: 4,
                        profileImage: widget.logoUrl,
                        description: _event!.caption,
                        tags: _event!.tags,
                        onTitleTap: () =>
                            _navigateToUserScreen(context, _user!),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.black, size: 24),
                            onPressed: () => _showBottomSheet(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment,
                                color: Colors.black, size: 24),
                            onPressed: () => _showBottomSheet(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share,
                                color: Colors.black, size: 24),
                            onPressed: () => _showBottomSheet(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_to_photos,
                                color: Colors.black, size: 24),
                            onPressed: () => _showBottomSheet(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToUserScreen(BuildContext context, User user) {
    context.go(
        '/calendar/event/${widget.eventId}/user/${user.id}?author=${widget.author}');
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                // Implémentez votre logique de partage ici
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text('Comment'),
              onTap: () {
                // Implémentez votre logique de commentaire ici
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Bookmark'),
              onTap: () {
                // Implémentez votre logique d'ajout aux favoris ici
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                // Implémentez votre logique de signalement ici
                Navigator.pop(context);
              },
            ),
            // Ajoutez d'autres options si nécessaire
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
