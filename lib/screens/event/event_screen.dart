import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/event/bloc/event_bloc.dart';
import 'package:bootdv2/screens/event/widgets/widgets.dart';

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
  bool _isUserAParticipant = false;
  String? _postRef;
  String? _userRefId;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventBloc>(context)
        .add(EventFetchEvent(eventId: widget.eventId));
    _fetchUserRefFromAuthor(widget.author);
    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.uid;
    if (userId != null) {
      _checkIfUserIsAParticipant(userId);
    } else {
      print('User ID is null');
    }
  }

  // Vérifie si userId est un participant de l'événement
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

  void _fetchUserRefFromAuthor(String author) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('brands')
          .where('author', isEqualTo: author)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot brandDoc = querySnapshot.docs.first;
        DocumentReference userRef = brandDoc.get('user_ref');
        _userRefId = userRef.id; // Stockez l'ID de référence de l'utilisateur
      } else {
        print(
            'Aucune correspondance pour l\'author "$author" trouvée dans la collection brands.');
      }
    } catch (e) {
      print(
          'Une erreur s\'est produite lors de la récupération de user_ref: $e');
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
                        onTitleTap: () => _navigateToUserScreen(context),
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
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  // Builds the post button
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

  // Construit le bouton pour naviguer vers le post de l'utilisateur
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

  void _navigateToUserScreen(BuildContext context) {
    final author = widget.author;
    context.push(
        '/calendar/event/${widget.eventId}/user/$_userRefId?username=$author');
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

  void _navigateToCreatePostScreen(BuildContext context) {
    GoRouter.of(context).push('/calendar/event/${widget.eventId}/create');
  }

  void _navigateToPostScreen(BuildContext context) {
    final title = widget.title;
    GoRouter.of(context).push(
        '/calendar/event/${widget.eventId}/post/$_postRef?username=$title');
  }

  @override
  bool get wantKeepAlive => true;
}
