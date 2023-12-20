import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/my_event/my_event_bloc.dart';
import 'package:bootdv2/screens/profile/widgets/mosaique_event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBrandTab1 extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;

  const ProfileBrandTab1({
    super.key,
    required this.state,
    required this.context,
  });

  @override
  State<ProfileBrandTab1> createState() => _ProfileBrandTab1State();
}

class _ProfileBrandTab1State extends State<ProfileBrandTab1>
    with AutomaticKeepAliveClientMixin<ProfileBrandTab1> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context
          .read<MyEventBloc>()
          .add(MyEventFetchEvents(userId: widget.state.user.id));
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MyEventBloc, MyEventState>(
      listener: (context, state) {
        if (state.status == MyEventStatus.initial && state.events.isEmpty) {
          context
              .read<MyEventBloc>()
              .add(MyEventFetchEvents(userId: widget.state.user.id));
        }
      },
      builder: (context, state) {
        return _buildBody(context, state);
      },
    );
  }
}

Widget _buildBody(BuildContext context, MyEventState state) {
  return MediaQuery.removePadding(
    context: context,
    removeTop: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        physics: const ClampingScrollPhysics(),
        cacheExtent: 10000,
        itemCount: state.events.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == state.events.length) {
            return state.status == MyEventStatus.paginating
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          } else {
            final event = state.events[index] ?? Event.empty;

            return FutureBuilder<String>(
              future: getMostLikedPostImageUrl(event.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.transparent),
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
                return MosaiqueEventCard(
                  imageUrl: snapshot.data!,
                  title: event.title,
                  logoUrl: event.author.logoUrl,
                  eventId: event.id,
                );
              },
            );
          }
        },
      ),
    ),
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
          final postData = postDoc.data() as Map<String, dynamic>?;
          return postData?['imageUrl'] as String? ?? '';
        } else {
          debugPrint("ProfileBrandTab1 - getMostLikedPostImageUrl : Referenced post document does not exist.");
        }
      } else {
        debugPrint("ProfileBrandTab1 - getMostLikedPostImageUrl : Post reference is null.");
      }
    } else {
      debugPrint("ProfileBrandTab1 - getMostLikedPostImageUrl : No posts found in the event's feed.");
    }
  } catch (e) {
    debugPrint(
        "ProfileBrandTab1 - getMostLikedPostImageUrl : An error occurred while fetching the most liked post image URL: $e");
  }
  return '';
}
