import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/event/bloc/event_bloc.dart';
import 'package:bootdv2/screens/event/widgets/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EventScreen extends StatefulWidget {
  final String eventId;
  final String fromPath;

  const EventScreen({
    super.key,
    required this.eventId,
    required this.fromPath,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isUserAParticipant = false;
  String? _postRef;
  String? _userRefId;

  EventRepository eventRepository = EventRepository();

  String title = '';
  String logoUrl = '';
  String author = '';
  Event? eventDetails;

  @override
  void initState() {
    // debugPrint("DEBUG : fromPath = ${widget.fromPath}");
    // debugPrint("DEBUG : VARIABLE = ${widget.eventId}");

    super.initState();
    _fetchEventDetails();
   BlocProvider.of<EventBloc>(context).add(EventFetchEvent(eventId: widget.eventId));
    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.uid;
    if (userId != null) {
      _checkIfUserIsAParticipant(userId);
    } else {
      debugPrint('User ID is null');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchEventDetails(); // Refetch event details if dependencies change
  }

  @override
  void didUpdateWidget(EventScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.eventId != oldWidget.eventId) {
      _fetchEventDetails(); // Refetch event details if event ID changes
    }
  }

  void _navigateToPostScreen(BuildContext context) {
    GoRouter.of(context).push('/post/$_postRef', extra: widget.fromPath);
  }

  void _fetchEventDetails() async {
    Event? event = await eventRepository.getEventById(widget.eventId);
    if (event != null) {
      setState(() {
        _userRefId = null; // Réinitialiser _userRefId avant de le mettre à jour
        title = event.title;
        logoUrl = event.logoUrl;
        author = event.author.author;
        eventDetails = event;
        _userRefId = event.user_ref.id;
        debugPrint("DEBUG : userRefId updated to = $_userRefId");
      });
    } else {
      debugPrint("No event found, _userRefId remains null");
    }
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

  Widget _buildEvent(BuildContext context, event, size) {
    return Scaffold(
      appBar: AppBarTitle(title: title),
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
                      title: author,
                      likes: 4,
                      description: event.caption,
                      tags: event.tags,
                      profileImage: event.logoUrl,
                      onTitleTap: () =>
                          _navigateToUserScreen(context, event.user_ref.id),
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
                          onPressed: () => _navigateToCommentScreen(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share,
                              color: Colors.black, size: 24),
                          onPressed: () => _showBottomSheetShare(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildListView(context, event),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton:
          (event.done == true) ? null : _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    if (_isUserAParticipant) {
      return _buildFloatingActionButtonMyPost(context);
    } else {
      return FloatingActionButton.extended(
        backgroundColor: couleurBleuClair2,
        onPressed: () => _navigateToCreatePostScreen(context),
        label: Text(AppLocalizations.of(context)!.translate('participate'),
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white)),
      );
    }
  }

  Widget _buildFloatingActionButtonMyPost(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () => _navigateToPostScreen(context),
      label: Text('Mon Post',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white)),
    );
  }

  Widget _buildListView(BuildContext context, Event event) {
    return Container(
      color: white,
      child: Column(
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

  Widget _buildLoadingIndicator() {
    return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
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

  void _showBottomSheetShare(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
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

  void _navigateToCreatePostScreen(BuildContext context) {
    GoRouter.of(context).go('/calendar/event/${widget.eventId}/create');
  }

  void _navigateToCommentScreen(BuildContext context) {
    context.push('/calendar/event/${widget.eventId}/comment');
  }

  void _navigateToUserScreen(BuildContext context, String userId) {
    debugPrint("DEBUG : Navigate to user with ID = $userId");
    context.push('/brand/$userId?username=$author').then((_) {
      _userRefId = null; // Reset _userRefId after navigation is done
      debugPrint("DEBUG : _userRefId reset to null after navigation");
    });
  }

  void _checkIfUserIsAParticipant(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Paths.events)
        .doc(widget.eventId)
        .collection('participants')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      _isUserAParticipant = querySnapshot.docs.isNotEmpty;
      if (_isUserAParticipant) {
        // Récupérez l'objet DocumentReference
        DocumentReference postRef = querySnapshot.docs.first.get('post_ref');
        // Enregistrez l'ID du document
        _postRef = postRef.id;
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
