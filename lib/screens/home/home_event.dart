import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeEvent extends StatefulWidget {
  HomeEvent({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _HomeEventState createState() => _HomeEventState();
}

class _HomeEventState extends State<HomeEvent>
    with AutomaticKeepAliveClientMixin<HomeEvent> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<HomeEventBloc>().add(HomeEventFetchEvents());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<HomeEventBloc, HomeEventState>(
      listener: (context, state) {
        if (state.status == HomeEventStatus.initial && state.events.isEmpty) {
          context.read<HomeEventBloc>().add(HomeEventFetchEvents());
        }
      },
      builder: (context, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(HomeEventState state) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.5,
      ),
      physics: const BouncingScrollPhysics(),
      cacheExtent: 10000,
      itemCount: state.events.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == state.events.length) {
          return state.status == HomeEventStatus.paginating
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        } else {
          final event = state.events[index] ?? Event.empty;

          return FutureBuilder<String>(
            future: getMostLikedPostImageUrl(event.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
                );
              }
              if (snapshot.hasError) {
                // Handle the error state
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Handle the case where there is no image URL
                return const Text('No image available');
              }
              return MosaiqueEventLongCard(
                imageUrl: snapshot.data!,
                title: event.title,
                logoUrl: event.author.logoUrl,
                eventId: event.id,
              );
            },
          );
        }
      },
    );
  }

  Future<String> getMostLikedPostImageUrl(String eventId) async {
    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('feed_event');

      final querySnapshot =
          await feedEventRef.orderBy('likes', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        final DocumentReference? postRef =
            data?['post_ref'] as DocumentReference?;

        if (postRef != null) {
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            final postData =
                postDoc.data() as Map<String, dynamic>?; // Cast as a map
            return postData?['imageUrl'] as String? ?? ''; // Use the map
          } else {
            debugPrint("Referenced post document does not exist.");
          }
        } else {
          debugPrint("Post reference is null.");
        }
      } else {
        debugPrint("No posts found in the event's feed.");
      }
    } catch (e) {
      debugPrint(
          "An error occurred while fetching the most liked post image URL: $e");
    }
    return '';
  }

  // Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
