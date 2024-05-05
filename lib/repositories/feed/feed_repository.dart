import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedRepository {
  final FirebaseFirestore _firebaseFirestore;

  FeedRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Post?>> getFeedOOTDFemale({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotdFemale)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedOotdFemale)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotdFemale)
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

    Future<List<Post?>> getFeedOOTDMan({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotdMan)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedOotdMan)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotdMan)
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

  Future<List<Post?>> getFeedMonthMan({
    required String userId,
    String? lastPostId,
  }) async {
    debugPrint(
        'getFeedMonthMan :  appelé pour userId: $userId, lastPostId: $lastPostId');
    QuerySnapshot postsSnap;

    if (lastPostId == null) {
      debugPrint(
          'getFeedMonthMan :  Aucun lastPostId fourni, récupération des premiers posts');
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonthMan)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
      debugPrint(
          'getFeedMonthMan :  Nombre de posts récupérés: ${postsSnap.docs.length}');
    } else {
      debugPrint(
          'getFeedMonthMan :  lastPostId fourni: $lastPostId, récupération des posts suivants');
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedMonthMan)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        debugPrint(
            'getFeedMonthMan :  Le document lastPostDoc n\'existe pas, retour d\'une liste vide');
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonthMan)
          .orderBy('likes', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
      debugPrint(
          'getFeedMonthMan :  Nombre de posts récupérés après le lastPostId: ${postsSnap.docs.length}');
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      DocumentReference postRef = doc['post_ref'];
      DocumentSnapshot postSnap = await postRef.get();

      if (postSnap.exists) {
        debugPrint('getFeedMonthMan :  Post trouvé pour ref: ${postRef.path}');
        return Post.fromDocument(postSnap);
      } else {
        debugPrint(
            'getFeedMonthMan :  Aucun post trouvé pour ref: ${postRef.path}');
        return null;
      }
    }).toList();

    final posts = await Future.wait(postFutures);
    debugPrint(
        'getFeedMonthMan :  Nombre total de posts construits: ${posts.length}');
    return posts;
  }

  Future<List<Post?>> getFeedMonthFemale({
    required String userId,
    String? lastPostId,
  }) async {
    debugPrint(
        'getFeedMonthFemale :  appelé pour userId: $userId, lastPostId: $lastPostId');
    QuerySnapshot postsSnap;

    if (lastPostId == null) {
      debugPrint(
          'getFeedMonthFemale :  Aucun lastPostId fourni, récupération des premiers posts');
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonthFemale)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
      debugPrint(
          'getFeedMonthFemale :  Nombre de posts récupérés: ${postsSnap.docs.length}');
    } else {
      debugPrint(
          'getFeedMonthFemale :  lastPostId fourni: $lastPostId, récupération des posts suivants');
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedMonthFemale)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        debugPrint(
            'getFeedMonthFemale :  Le document lastPostDoc n\'existe pas, retour d\'une liste vide');
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonthFemale)
          .orderBy('likes', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
      debugPrint(
          'getFeedMonthFemale :  Nombre de posts récupérés après le lastPostId: ${postsSnap.docs.length}');
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      DocumentReference postRef = doc['post_ref'];
      DocumentSnapshot postSnap = await postRef.get();

      if (postSnap.exists) {
        debugPrint('getFeedMonthFemale :  Post trouvé pour ref: ${postRef.path}');
        return Post.fromDocument(postSnap);
      } else {
        debugPrint(
            'getFeedMonthFemale :  Aucun post trouvé pour ref: ${postRef.path}');
        return null;
      }
    }).toList();

    final posts = await Future.wait(postFutures);
    debugPrint(
        'getFeedMonthFemale :  Nombre total de posts construits: ${posts.length}');
    return posts;
  }

  Future<List<Post?>> getFeedEvent({
    required String eventId,
    required String userId,
    String? lastPostId,
  }) async {
    debugPrint(
        'Method getFeedEvent : called with eventId: $eventId, userId: $userId, lastPostId: $lastPostId');
    QuerySnapshot postsSnap;
    final eventDocRef = _firebaseFirestore.collection('events').doc(eventId);

    if (lastPostId == null) {
      debugPrint('Method getFeedEvent : Fetching initial events...');
      postsSnap = await eventDocRef
          .collection('feed_event')
          .orderBy('likes', descending: true)
          .limit(10)
          .get();
      debugPrint(
          'Method getFeedEvent : Fetched ${postsSnap.docs.length} initial events.');
    } else {
      debugPrint(
          'Method getFeedEvent : Fetching posts after postId: $lastPostId');
      final lastPostDoc =
          await eventDocRef.collection('feed_event').doc(lastPostId).get();

      if (!lastPostDoc.exists) {
        debugPrint(
            'Method getFeedEvent : Last post not found. Returning empty list.');
        return [];
      }

      postsSnap = await eventDocRef
          .collection('feed_event')
          .orderBy('likes', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
      debugPrint(
          'Method getFeedEvent : Fetched ${postsSnap.docs.length} posts after postId: $lastPostId');
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      try {
        if (doc.exists) {
          debugPrint(
              'Method getFeedEvent : Processing post document with ID: ${doc.id}');
          DocumentReference postRef = doc['post_ref'];
          DocumentSnapshot postSnap = await postRef.get();
          if (postSnap.exists) {
            return Post.fromDocument(postSnap);
          } else {
            debugPrint(
                'Method getFeedEvent : Referenced post document does not exist.');
          }
        } else {
          debugPrint(
              'Method getFeedEvent : Document does not exist, skipping.');
        }
      } catch (e) {
        debugPrint(
            'Method getFeedEvent : Error processing post document: ${doc.id}, Error: $e');
      }
      return null;
    }).toList();

    final posts = await Future.wait(postFutures);
    debugPrint('Method getFeedEvent : Total posts processed: ${posts.length}');
    return posts;
  }

  Future<List<Post?>> getFeedFollowing({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('date', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('date', descending: true)
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

  Future<List<Post?>> getFeedExplorer({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotdMan)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedOotdMan)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotdMan)
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

  Future<List<Post?>> getFeedCollection({
    required String collectionId,
    required String userId,
    String? lastPostId,
  }) async {
    debugPrint(
        'getFeedCollection : called with collectionId: $collectionId, userId: $userId, lastPostId: $lastPostId');
    QuerySnapshot postsSnap;
    final collectionDocRef =
        _firebaseFirestore.collection('collections').doc(collectionId);

    if (lastPostId == null) {
      debugPrint('getFeedCollection : Fetching initial collections...');
      postsSnap = await collectionDocRef
          .collection('feed_collection')
          .orderBy('date', descending: true)
          .limit(4)
          .get();
      debugPrint(
          'getFeedCollection : Fetched ${postsSnap.docs.length} initial collections.');
    } else {
      debugPrint(
          'getFeedCollection : Fetching posts after postId: $lastPostId');
      final lastPostDoc = await collectionDocRef
          .collection('feed_collection')
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        debugPrint(
            'getFeedCollection : Last post not found. Returning empty list.');
        return [];
      }

      postsSnap = await collectionDocRef
          .collection('feed_collection')
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
      debugPrint(
          'getFeedCollection : Fetched ${postsSnap.docs.length} posts after postId: $lastPostId');
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      try {
        if (doc.exists) {
          debugPrint(
              'getFeedCollection : Processing post document with ID: ${doc.id}');
          DocumentReference postRef = doc['post_ref'];
          DocumentSnapshot postSnap = await postRef.get();
          if (postSnap.exists) {
            return Post.fromDocument(postSnap);
          } else {
            debugPrint(
                'getFeedCollection : Referenced post document does not exist.');
          }
        } else {
          debugPrint('getFeedCollection : Document does not exist, skipping.');
        }
      } catch (e) {
        debugPrint(
            'getFeedCollection : Error processing post document: ${doc.id}, Error: $e');
      }
      return null;
    }).toList();

    final posts = await Future.wait(postFutures);
    debugPrint('getFeedCollection : Total posts processed: ${posts.length}');
    return posts;
  }

  Future<List<Post?>> getFeedMyLikes({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.likes)
          .orderBy('date', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.likes)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.posts)
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

  Future<List<Post?>> getFeedSwipe({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.posts)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.posts)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotdMan)
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
}
