// ignore_for_file: avoid_print

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/event_model.dart';
import 'package:bootdv2/repositories/post/base_post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  @override
  Future<void> createComment({
    required Post post,
    required Comment comment,
  }) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument());

    final notification = Notif(
      type: NotifType.comment,
      fromUser: comment.author,
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
          .collection(Paths.posts)
          .orderBy('date', descending: true)
          .limit(5)
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
          .collection(Paths.posts)
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
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonth)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedMonth)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonth)
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

  Future<Post?> getPostById(String postId) async {
    try {
      DocumentSnapshot postSnap =
          await _firebaseFirestore.collection(Paths.posts).doc(postId).get();

      if (postSnap.exists) {
        return Post.fromDocument(postSnap);
      } else {
        // Handle the case where the post does not exist.
        print("Le post n'existe pas.");
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the fetch.
      print(e.toString());
      return null;
    }
  }

  Future<List<Post?>> getFeedEvent({
    required String eventId,
    required String userId,
    String? lastPostId,
  }) async {
    print(
        'Method getFeedEvent : called with eventId: $eventId, userId: $userId, lastPostId: $lastPostId');
    QuerySnapshot postsSnap;
    final eventDocRef = _firebaseFirestore.collection('events').doc(eventId);

    if (lastPostId == null) {
      print('Method getFeedEvent : Fetching initial events...');
      postsSnap = await eventDocRef
          .collection('feed_event')
          .orderBy('likes', descending: true)
          .limit(4)
          .get();
      print(
          'Method getFeedEvent : Fetched ${postsSnap.docs.length} initial events.');
    } else {
      print('Method getFeedEvent : Fetching posts after postId: $lastPostId');
      final lastPostDoc =
          await eventDocRef.collection('feed_event').doc(lastPostId).get();

      if (!lastPostDoc.exists) {
        print(
            'Method getFeedEvent : Last post not found. Returning empty list.');
        return [];
      }

      postsSnap = await eventDocRef
          .collection('feed_event')
          .orderBy('likes', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
      print(
          'Method getFeedEvent : Fetched ${postsSnap.docs.length} posts after postId: $lastPostId');
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      try {
        if (doc.exists) {
          print(
              'Method getFeedEvent : Processing post document with ID: ${doc.id}');
          DocumentReference postRef = doc['post_ref'];
          DocumentSnapshot postSnap = await postRef.get();
          if (postSnap.exists) {
            return Post.fromDocument(postSnap);
          } else {
            print(
                'Method getFeedEvent : Referenced post document does not exist.');
          }
        } else {
          print('Method getFeedEvent : Document does not exist, skipping.');
        }
      } catch (e) {
        print(
            'Method getFeedEvent : Error processing post document: ${doc.id}, Error: $e');
      }
      return null;
    }).toList();

    final posts = await Future.wait(postFutures);
    print('Method getFeedEvent : Total posts processed: ${posts.length}');
    return posts;
  }

  Future<List<Event?>> getEventsDone({
    required String userId,
    String? lastEventId,
  }) async {
    try {
      print(
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
          print('Method getEventsDone : Last event document does not exist.');
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

      print(
          'Method getEventsDone : Event documents fetched. Converting to Event objects...');
      List<Future<Event?>> futureEvents =
          eventSnap.docs.map((doc) => Event.fromDocument(doc)).toList();

      // Use Future.wait to resolve all events
      List<Event?> events = await Future.wait(futureEvents);

      print(
          'Method getEventsDone : Event objects created. Total events: ${events.length}');
      // Here, you might also print an event for debugging
      if (events.isNotEmpty) {
        print('Method getEventsDone : First event details: ${events.first}');
      }

      return events;
    } catch (e) {
      print(
          'Method getEventsDone : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<Event?> getLatestEvent() async {
    try {
      print(
          'Method getLatestEvent: Attempting to fetch the latest event document from Firestore...');
      // Fetch the latest event by date
      QuerySnapshot eventSnap = await _firebaseFirestore
          .collection(Paths.events)
          .where('done', isEqualTo: false)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (eventSnap.docs.isNotEmpty) {
        print(
            'Method getLatestEvent: Latest event document fetched. Converting to Event object...');
        DocumentSnapshot doc = eventSnap.docs.first;
        Event? latestEvent = await Event.fromDocument(doc);
        print(
            'Method getLatestEvent: Event data - ${latestEvent?.toDocument()}');
        return latestEvent;
      } else {
        print('Method getLatestEvent: No events found.');
        return null;
      }
    } catch (e) {
      print(
          'Method getLatestEvent: An error occurred while fetching the latest event: $e');
      return null;
    }
  }

  Future<List<Event>> getThisWeekEvents() async {
    List<Event> eventsList = [];
    try {
      print(
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
        print('Method getThisWeekEvents: Events fetched successfully.');
      } else {
        print(
            'Method getThisWeekEvents: No events found for the current week.');
      }
    } catch (e) {
      print(
          'Method getThisWeekEvents: Error occurred while fetching events - $e');
    }
    return eventsList;
  }

  Future<Event?> getEventById(String eventId) async {
    try {
      DocumentSnapshot eventSnap =
          await _firebaseFirestore.collection(Paths.events).doc(eventId).get();

      if (eventSnap.exists) {
        print(
            'Method getEventById : Event document found. Converting to Event object...');
        return Event.fromDocument(eventSnap);
      } else {
        print("Method getEventById : L'événement n'existe pas.");
        return null;
      }
    } catch (e) {
      print(
          'Method getEventById : Une erreur est survenue lors de la récupération de l\'événement: ${e.toString()}');
      return null;
    }
  }
}
