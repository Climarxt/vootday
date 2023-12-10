import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedRepository {
  final FirebaseFirestore _firebaseFirestore;

  FeedRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Post?>> getFeedOOTD({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotd)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedOotd)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotd)
          .orderBy('likes', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      DocumentReference postRef = doc['post_ref'];
      DocumentSnapshot postSnap = await postRef.get();
      if (postSnap.exists) {
        return Post.fromDocument(postSnap);
      }
      return null;
    }).toList();

    final posts = await Future.wait(postFutures);
    return posts;
  }

  Future<List<Post?>> getFeedMonth({
    required String userId,
    String? lastPostId,
  }) async {
    debugPrint(
        'getFeedMonth :  appelé pour userId: $userId, lastPostId: $lastPostId');
    QuerySnapshot postsSnap;

    if (lastPostId == null) {
      debugPrint(
          'getFeedMonth :  Aucun lastPostId fourni, récupération des premiers posts');
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonth)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
      debugPrint(
          'getFeedMonth :  Nombre de posts récupérés: ${postsSnap.docs.length}');
    } else {
      debugPrint(
          'getFeedMonth :  lastPostId fourni: $lastPostId, récupération des posts suivants');
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedMonth)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        debugPrint(
            'getFeedMonth :  Le document lastPostDoc n\'existe pas, retour d\'une liste vide');
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonth)
          .orderBy('likes', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
      debugPrint(
          'getFeedMonth :  Nombre de posts récupérés après le lastPostId: ${postsSnap.docs.length}');
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      DocumentReference postRef = doc['post_ref'];
      DocumentSnapshot postSnap = await postRef.get();

      if (postSnap.exists) {
        debugPrint('getFeedMonth :  Post trouvé pour ref: ${postRef.path}');
        return Post.fromDocument(postSnap);
      } else {
        debugPrint(
            'getFeedMonth :  Aucun post trouvé pour ref: ${postRef.path}');
        return null;
      }
    }).toList();

    final posts = await Future.wait(postFutures);
    debugPrint(
        'getFeedMonth :  Nombre total de posts construits: ${posts.length}');
    return posts;
  }
}
