import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTab3 extends StatefulWidget {
  final String userId;

  const ProfileTab3({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileTab3> createState() => _ProfileTab3State();
}

class _ProfileTab3State extends State<ProfileTab3> {
  @override
  void initState() {
    super.initState();
    context.read<YourCollectionBloc>().add(YourCollectionClean());
    context
        .read<YourCollectionBloc>()
        .add(YourCollectionFetchCollections(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YourCollectionBloc, YourCollectionState>(
      listener: (context, state) {
        if (state.status == YourCollectionStatus.initial &&
            state.collections.isEmpty) {
          context
              .read<YourCollectionBloc>()
              .add(YourCollectionFetchCollections(userId: widget.userId));
        }
      },
      builder: (context, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(YourCollectionState state) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        physics: const ClampingScrollPhysics(),
        cacheExtent: 10000,
        itemCount: state.collections.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == state.collections.length) {
            return state.status == YourCollectionStatus.paginating
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          } else {
            final collection = state.collections[index] ?? Collection.empty;

            return FutureBuilder<String>(
              future: getMostRecentPostImageUrl(collection.id),
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
                  return Text('No image available');
                }
                return MosaiqueCollectionCard(
                  imageUrl: snapshot.data!,
                  name: collection.title,
                  collectionId: collection.id,
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<String> getMostRecentPostImageUrl(String collectionId) async {
    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection');

      final querySnapshot =
          await feedEventRef.orderBy('date', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        final DocumentReference? postRef =
            data?['post_ref'] as DocumentReference?;

        if (postRef != null) {
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            final postData = postDoc.data() as Map<String, dynamic>?;
            debugPrint("Referenced post document exist.");
            return postData?['imageUrl'] as String? ?? '';
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
    return 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';
  }
}
