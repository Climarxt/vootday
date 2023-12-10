import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTab3 extends StatefulWidget {
  const ProfileTab3({super.key});

  @override
  State<ProfileTab3> createState() => _ProfileTab3State();
}

class _ProfileTab3State extends State<ProfileTab3> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCollectionBloc, MyCollectionState>(
      listener: (context, state) {
        if (state.status == MyCollectionStatus.initial &&
            state.collections.isEmpty) {
          context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());
        }
      },
      builder: (context, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(MyCollectionState state) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.8,
      ),
      physics: const ClampingScrollPhysics(),
      cacheExtent: 10000,
      itemCount: state.collections.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == state.collections.length) {
          return state.status == MyCollectionStatus.paginating
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        } else {
          final collection = state.collections[index] ?? Collection.empty;

          return FutureBuilder<String>(
            future: getMostRecentPostImageUrl(collection.id),
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
    return 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder_logo.svg?alt=media&token=aaeb5635-dd41-4b9e-97c8-ad2718564d23';
  }
}
