import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/event/bloc/event_bloc.dart';
import 'package:bootdv2/screens/event/widgets/profile_image_event.dart';
import 'package:bootdv2/screens/event/widgets/section_buttons_event.dart';
import 'package:bootdv2/screens/post/widgets/image_loader.dart';
import 'package:bootdv2/widgets/appbar/appbar_title.dart';
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
  User? _user;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventBloc>(context)
        .add(EventFetchEvent(eventId: widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    super.build(context);
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state.status == EventStatus.loading) {
          return _buildLoadingIndicator();
        } else if (state.status == EventStatus.loaded) {
          return _buildEvent(context, state.event ?? Event.empty, size);
        } else {
          return _buildLoadingIndicator();
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
  }

  Widget _buildEvent(BuildContext context, event, size) {
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
                  imageProvider: event.imageProvider,
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
                        description: event.caption,
                        tags: event.tags,
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
                const SizedBox(height: 8),
                _buildListView(context,event),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _navigateToUserScreen(BuildContext context, User user) {
    context.go(
        '/calendar/event/${widget.eventId}/user/${user.id}?author=${widget.author}');
  }

  Widget _buildListView(BuildContext context, Event event) {
    return Container(
      color: white,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonsSectionEvent(
            participants: event.participants,
            reward: event.reward,
            dateEnd: event.dateEnd,
            dateEvent: event.dateEvent,
          ),
        ],
      ),
    );
  }

  // Builds the post button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () {},
      label: Text(AppLocalizations.of(context)!.translate('participate'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white)),
    );
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
