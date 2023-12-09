// ignore_for_file: avoid_debugPrint

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/collection_model.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/base_post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/repositories/repositories.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> deletePost({required String postId}) async {
    WriteBatch batch = _firebaseFirestore.batch();
    debugPrint('Début de la suppression du post avec ID: $postId');

    // Suppression du post dans la collection 'posts'
    DocumentReference postRef =
        _firebaseFirestore.collection(Paths.posts).doc(postId);
    debugPrint('Suppression du post dans la collection posts');
    batch.delete(postRef);

    // Suppression des références du post dans les sous-collections
    await _deletePostReferencesInSubCollections(batch, postRef, 'participants');
    await _deletePostReferencesInSubCollections(batch, postRef, 'feed_event');
    await _deletePostReferencesInSubCollections(batch, postRef, 'feed_month');
    await _deletePostReferencesInSubCollections(batch, postRef, 'feed_ootd');

    // Exécution du batch pour effectuer toutes les suppressions
    debugPrint(
        'Exécution du batch pour la suppression du post et des références associées');
    await batch.commit();
    debugPrint('Suppression terminée pour le post avec ID: $postId');
  }

  Future<void> _deletePostReferencesInSubCollections(
      WriteBatch batch, DocumentReference postRef, String subCollection) async {
    debugPrint('Recherche du post dans les sous-collections $subCollection');
    QuerySnapshot snapshot = await _firebaseFirestore
        .collectionGroup(subCollection)
        .where('post_ref', isEqualTo: postRef)
        .get();

    if (snapshot.docs.isEmpty) {
      debugPrint(
          'Aucune référence trouvée dans $subCollection pour le post_ref: $postRef');
    } else {
      debugPrint(
          'Nombre de références trouvées dans $subCollection: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        debugPrint(
            'Suppression de la référence: ${doc.id} dans $subCollection dans le batch');
        batch.delete(doc.reference);
      }
    }
  }

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  @override
  Future<void> createComment({
    required Post post,
    required Comment comment,
  }) async {
    debugPrint('Début de la méthode createComment');

    debugPrint('Ajout du commentaire dans Firestore');
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument())
        .then((_) => debugPrint('Commentaire ajouté avec succès'))
        .catchError(
            (e) => debugPrint('Erreur lors de l\'ajout du commentaire: $e'));

    debugPrint('Création de la notification');
    final notification = Notif(
      type: NotifType.comment,
      fromUser: comment.author,
      post: post,
      date: DateTime.now(),
    );

    debugPrint('Ajout de la notification dans Firestore');
    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(post.author.id)
        .collection(Paths.userNotifications)
        .add(notification.toDocument())
        .then((_) => debugPrint('Notification ajoutée avec succès'))
        .catchError((e) =>
            debugPrint('Erreur lors de l\'ajout de la notification: $e'));

    debugPrint('Fin de la méthode createComment');
  }

  @override
  void createLike({
    required Post post,
    required String userId,
  }) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(post.id)
        .collection(Paths.postLikes)
        .doc(userId)
        .set({});

    final notification = Notif(
      type: NotifType.like,
      fromUser: User.empty.copyWith(id: userId),
      post: post,
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(post.author.id)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  @override
  Stream<List<Future<Post?>>> getUserPosts({required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  @override
  Stream<List<Future<Comment?>>> getPostComments({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

  @override
  Future<Set<String>> getLikedPostIds({
    required String userId,
    required List<Post?> posts,
  }) async {
    final postIds = <String>{};
    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection(Paths.likes)
          .doc(post!.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .get();
      if (likeDoc.exists) {
        postIds.add(post.id!);
      }
    }
    return postIds;
  }

  @override
  void deleteLike({required String postId, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .doc(userId)
        .delete();
  }

  @override
  Future<List<Post?>> getUserFeed({
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
          .limit(5)
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
          .limit(3)
          .get();
    }

    final posts = Future.wait(
      postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList(),
    );
    return posts;
  }

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

  Future<Post?> getPostById(String postId) async {
    try {
      DocumentSnapshot postSnap =
          await _firebaseFirestore.collection(Paths.posts).doc(postId).get();

      if (postSnap.exists) {
        return Post.fromDocument(postSnap);
      } else {
        // Handle the case where the post does not exist.
        debugPrint("Le post n'existe pas.");
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the fetch.
      debugPrint(e.toString());
      return null;
    }
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
          .limit(4)
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

  Future<List<Event?>> getEventsDone({
    required String userId,
    String? lastEventId,
  }) async {
    try {
      debugPrint(
          'Method getEventsDone : Attempting to fetch event documents from Firestore...');
      QuerySnapshot eventSnap;
      if (lastEventId == null) {
        // Initial fetch
        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .orderBy('dateEvent',
                descending: true) // Assume we order by the event date.
            .limit(100) // Or some other limit you prefer.
            .get();
      } else {
        // Pagination fetch
        final lastEventDoc = await _firebaseFirestore
            .collection(Paths.events)
            .doc(lastEventId)
            .get();

        if (!lastEventDoc.exists) {
          debugPrint(
              'Method getEventsDone : Last event document does not exist.');
          return [];
        }

        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .orderBy('dateEvent', descending: true)
            .startAfterDocument(lastEventDoc)
            .limit(2) // Fetch next set of events.
            .get();
      }

      debugPrint(
          'Method getEventsDone : Event documents fetched. Converting to Event objects...');
      List<Future<Event?>> futureEvents =
          eventSnap.docs.map((doc) => Event.fromDocument(doc)).toList();

      // Use Future.wait to resolve all events
      List<Event?> events = await Future.wait(futureEvents);

      debugPrint(
          'Method getEventsDone : Event objects created. Total events: ${events.length}');
      // Here, you might also debugPrint an event for debugging
      if (events.isNotEmpty) {
        debugPrint(
            'Method getEventsDone : First event details: ${events.first}');
      }

      return events;
    } catch (e) {
      debugPrint(
          'Method getEventsDone : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<Event?> getLatestEvent() async {
    try {
      debugPrint(
          'Method getLatestEvent: Attempting to fetch the latest event document from Firestore...');
      // Fetch the latest event by date
      QuerySnapshot eventSnap = await _firebaseFirestore
          .collection(Paths.events)
          .where('done', isEqualTo: false)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (eventSnap.docs.isNotEmpty) {
        debugPrint(
            'Method getLatestEvent: Latest event document fetched. Converting to Event object...');
        DocumentSnapshot doc = eventSnap.docs.first;
        Event? latestEvent = await Event.fromDocument(doc);
        debugPrint(
            'Method getLatestEvent: Event data - ${latestEvent?.toDocument()}');
        return latestEvent;
      } else {
        debugPrint('Method getLatestEvent: No events found.');
        return null;
      }
    } catch (e) {
      debugPrint(
          'Method getLatestEvent: An error occurred while fetching the latest event: $e');
      return null;
    }
  }

  Future<List<Event>> getThisWeekEvents() async {
    List<Event> eventsList = [];
    try {
      debugPrint(
          'Method getThisWeekEvents: Attempting to fetch events from Firestore for the current week.');

      DateTime now = DateTime.now();
      DateTime oneWeekFromNow = now.add(Duration(days: 7));

      QuerySnapshot eventSnap = await FirebaseFirestore.instance
          .collection('events')
          .where('done', isEqualTo: false)
          .where('dateEvent', isGreaterThan: now)
          .where('dateEvent', isLessThan: oneWeekFromNow)
          .orderBy('dateEvent', descending: true)
          .get();

      if (eventSnap.docs.isNotEmpty) {
        for (var doc in eventSnap.docs) {
          Event? event = await Event.fromDocument(doc);
          if (event != null) {
            eventsList.add(event);
          }
        }
        debugPrint('Method getThisWeekEvents: Events fetched successfully.');
      } else {
        debugPrint(
            'Method getThisWeekEvents: No events found for the current week.');
      }
    } catch (e) {
      debugPrint(
          'Method getThisWeekEvents: Error occurred while fetching events - $e');
    }
    return eventsList;
  }

  Future<List<Event>> getComingSoonEvents() async {
    List<Event> eventsList = [];
    try {
      debugPrint(
          'Method getComingSoonEvents: Attempting to fetch future events from Firestore.');

      DateTime now = DateTime.now();
      DateTime oneWeekFromNow = now.add(Duration(days: 7));

      QuerySnapshot eventSnap = await FirebaseFirestore.instance
          .collection('events')
          .where('done', isEqualTo: false)
          .where('dateEvent', isGreaterThanOrEqualTo: oneWeekFromNow)
          .orderBy('dateEvent', descending: false)
          .get();

      if (eventSnap.docs.isNotEmpty) {
        for (var doc in eventSnap.docs) {
          Event? event = await Event.fromDocument(doc);
          if (event != null) {
            eventsList.add(event);
          }
        }
        debugPrint(
            'Method getComingSoonEvents: Future events fetched successfully.');
      } else {
        debugPrint('Method getComingSoonEvents: No future events found.');
      }
    } catch (e) {
      debugPrint(
          'Method getComingSoonEvents: Error occurred while fetching future events - $e');
    }
    return eventsList;
  }

  Future<Event?> getEventById(String eventId) async {
    try {
      DocumentSnapshot eventSnap =
          await _firebaseFirestore.collection(Paths.events).doc(eventId).get();

      if (eventSnap.exists) {
        debugPrint(
            'Method getEventById : Event document found. Converting to Event object...');
        return Event.fromDocument(eventSnap);
      } else {
        debugPrint("Method getEventById : L'événement n'existe pas.");
        return null;
      }
    } catch (e) {
      debugPrint(
          'Method getEventById : Une erreur est survenue lors de la récupération de l\'événement: ${e.toString()}');
      return null;
    }
  }

  Future<List<Post?>> getExplorer({
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

  Future<void> createPostEvent(
      {required Post post, required String eventId}) async {
    // Créer une référence de document pour le nouveau post.
    DocumentReference postRef =
        _firebaseFirestore.collection(Paths.posts).doc();

    // Préparer le document pour le post avec une référence aléatoire.
    final postDocument = post.copyWith(id: postRef.id).toDocument();

    // Créer un document pour le participant dans la sous-collection de l'eventId avec une référence au post.
    final participantDocument = {'post_ref': postRef, 'userId': post.author.id};

    // Écrire les deux documents en utilisant une transaction pour garantir que les deux opérations réussissent ou échouent ensemble.
    await _firebaseFirestore.runTransaction((transaction) async {
      // Ajouter le nouveau post à la collection des posts.
      transaction.set(postRef, postDocument);

      // Ajouter la référence du post au document du participant dans la sous-collection des participants.
      DocumentReference participantRef = _firebaseFirestore
          .collection(Paths.events)
          .doc(eventId)
          .collection('participants')
          .doc();
      transaction.set(participantRef, participantDocument);
    });
  }

  Future<List<Collection?>> getMyCollection({
    required String userId,
  }) async {
    try {
      debugPrint(
          'Method getMyCollection : Attempting to fetch collection documents from Firestore...');
      QuerySnapshot collectionSnap;
      {
        collectionSnap = await _firebaseFirestore
            .collection(Paths.collections)
            .orderBy('date', descending: true)
            .get();
      }

      debugPrint(
          'Method getMyCollection : Collection documents fetched. Converting to Collection objects...');
      List<Future<Collection?>> futureCollections = collectionSnap.docs
          .map((doc) => Collection.fromDocument(doc))
          .toList();

      // Use Future.wait to resolve all events
      List<Collection?> collections = await Future.wait(futureCollections);

      debugPrint(
          'Method getMyCollection : Collection objects created. Total events: ${collections.length}');
      // Here, you might also debugPrint an event for debugging
      if (collections.isNotEmpty) {
        debugPrint(
            'Method getMyCollection : First event details: ${collections.first}');
      }

      return collections;
    } catch (e) {
      debugPrint(
          'Method getMyCollection : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<List<Post?>> getFeedCollection({
    required String collectionId,
    required String userId,
    String? lastPostId,
  }) async {
    debugPrint(
        'Method getFeedCollection : called with collectionId: $collectionId, userId: $userId, lastPostId: $lastPostId');
    QuerySnapshot postsSnap;
    final collectionDocRef = _firebaseFirestore.collection('collections').doc(collectionId);

    if (lastPostId == null) {
      debugPrint('Method getFeedCollection : Fetching initial collections...');
      postsSnap = await collectionDocRef
          .collection('feed_collection')
          .orderBy('date', descending: true)
          .limit(4)
          .get();
      debugPrint(
          'Method getFeedCollection : Fetched ${postsSnap.docs.length} initial collections.');
    } else {
      debugPrint(
          'Method getFeedCollection : Fetching posts after postId: $lastPostId');
      final lastPostDoc =
          await collectionDocRef.collection('feed_collection').doc(lastPostId).get();

      if (!lastPostDoc.exists) {
        debugPrint(
            'Method getFeedCollection : Last post not found. Returning empty list.');
        return [];
      }

      postsSnap = await collectionDocRef
          .collection('feed_collection')
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
      debugPrint(
          'Method getFeedCollection : Fetched ${postsSnap.docs.length} posts after postId: $lastPostId');
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      try {
        if (doc.exists) {
          debugPrint(
              'Method getFeedCollection : Processing post document with ID: ${doc.id}');
          DocumentReference postRef = doc['post_ref'];
          DocumentSnapshot postSnap = await postRef.get();
          if (postSnap.exists) {
            return Post.fromDocument(postSnap);
          } else {
            debugPrint(
                'Method getFeedCollection : Referenced post document does not exist.');
          }
        } else {
          debugPrint(
              'Method getFeedCollection : Document does not exist, skipping.');
        }
      } catch (e) {
        debugPrint(
            'Method getFeedCollection : Error processing post document: ${doc.id}, Error: $e');
      }
      return null;
    }).toList();

    final posts = await Future.wait(postFutures);
    debugPrint('Method getFeedCollection : Total posts processed: ${posts.length}');
    return posts;
  }
}
