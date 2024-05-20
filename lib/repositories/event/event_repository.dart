import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/comment_event_model.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventRepository {
  final FirebaseFirestore _firebaseFirestore;

  EventRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<Event?> getEventById(String eventId) async {
    try {
      DocumentSnapshot eventSnap =
          await _firebaseFirestore.collection(Paths.events).doc(eventId).get();

      if (eventSnap.exists) {
        debugPrint(
            'getEventById : Event document found. Converting to Event object...');
        return Event.fromDocument(eventSnap);
      } else {
        debugPrint("getEventById : L'événement n'existe pas.");
        return null;
      }
    } catch (e) {
      debugPrint(
          'getEventById : Une erreur est survenue lors de la récupération de l\'événement: ${e.toString()}');
      return null;
    }
  }

  Future<Event?> getLatestEvent() async {
    try {
      debugPrint(
          'getLatestEvent: Attempting to fetch the latest event document from Firestore...');
      // Fetch the latest event by date
      QuerySnapshot eventSnap = await _firebaseFirestore
          .collection(Paths.events)
          .where('done', isEqualTo: false)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (eventSnap.docs.isNotEmpty) {
        debugPrint(
            'getLatestEvent: Latest event document fetched. Converting to Event object...');
        DocumentSnapshot doc = eventSnap.docs.first;
        Event? latestEvent = await Event.fromDocument(doc);
        debugPrint('getLatestEvent: Event data - ${latestEvent?.toDocument()}');
        return latestEvent;
      } else {
        debugPrint('getLatestEvent: No events found.');
        return null;
      }
    } catch (e) {
      debugPrint(
          'getLatestEvent: An error occurred while fetching the latest event: $e');
      return null;
    }
  }

  Future<List<Event?>> getEventsDone({
    required String userId,
    String? lastEventId,
  }) async {
    try {
      debugPrint(
          'getEventsDone : Attempting to fetch event documents from Firestore...');
      QuerySnapshot eventSnap;
      if (lastEventId == null) {
        // Initial fetch
        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .orderBy('dateEvent', descending: true)
            .limit(100)
            .get();
      } else {
        // Pagination fetch
        final lastEventDoc = await _firebaseFirestore
            .collection(Paths.events)
            .doc(lastEventId)
            .get();

        if (!lastEventDoc.exists) {
          debugPrint('getEventsDone : Last event document does not exist.');
          return [];
        }

        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .orderBy('dateEvent', descending: true)
            .startAfterDocument(lastEventDoc)
            .limit(2)
            .get();
      }

      debugPrint(
          'getEventsDone : Event documents fetched. Converting to Event objects...');
      List<Future<Event?>> futureEvents =
          eventSnap.docs.map((doc) => Event.fromDocument(doc)).toList();

      // Use Future.wait to resolve all events
      List<Event?> events = await Future.wait(futureEvents);

      debugPrint(
          'getEventsDone : Event objects created. Total events: ${events.length}');
      // Here, you might also debugPrint an event for debugging
      if (events.isNotEmpty) {
        debugPrint('getEventsDone : First event details: ${events.first}');
      }

      return events;
    } catch (e) {
      debugPrint(
          'getEventsDone : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<List<Event?>> getEventsManDone({
    required String userId,
    String? lastEventId,
  }) async {
    try {
      debugPrint(
          'getEventsManDone : Attempting to fetch event documents from Firestore...');
      QuerySnapshot eventSnap;
      if (lastEventId == null) {
        // Initial fetch
        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .where('selectedGender', isEqualTo: 'Masculin')
            .orderBy('dateEvent', descending: true)
            .limit(100)
            .get();
      } else {
        // Pagination fetch
        final lastEventDoc = await _firebaseFirestore
            .collection(Paths.events)
            .doc(lastEventId)
            .get();

        if (!lastEventDoc.exists) {
          debugPrint('getEventsManDone : Last event document does not exist.');
          return [];
        }

        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .where('selectedGender', isEqualTo: 'Masculin')
            .orderBy('dateEvent', descending: true)
            .startAfterDocument(lastEventDoc)
            .limit(2)
            .get();
      }

      debugPrint(
          'getEventsManDone : Event documents fetched. Converting to Event objects...');
      List<Future<Event?>> futureEvents =
          eventSnap.docs.map((doc) => Event.fromDocument(doc)).toList();

      // Use Future.wait to resolve all events
      List<Event?> events = await Future.wait(futureEvents);

      debugPrint(
          'getEventsManDone : Event objects created. Total events: ${events.length}');
      // Here, you might also debugPrint an event for debugging
      if (events.isNotEmpty) {
        debugPrint('getEventsManDone : First event details: ${events.first}');
      }

      return events;
    } catch (e) {
      debugPrint(
          'getEventsManDone : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<List<Event?>> getEventsWomanDone({
    required String userId,
    String? lastEventId,
  }) async {
    try {
      debugPrint(
          'getEventsWomanDone : Attempting to fetch event documents from Firestore...');
      QuerySnapshot eventSnap;
      if (lastEventId == null) {
        // Initial fetch
        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .where('selectedGender', isEqualTo: 'Féminin')
            .orderBy('dateEvent', descending: true)
            .limit(100)
            .get();
      } else {
        // Pagination fetch
        final lastEventDoc = await _firebaseFirestore
            .collection(Paths.events)
            .doc(lastEventId)
            .get();

        if (!lastEventDoc.exists) {
          debugPrint(
              'getEventsWomanDone : Last event document does not exist.');
          return [];
        }

        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .where('selectedGender', isEqualTo: 'Féminin')
            .orderBy('dateEvent', descending: true)
            .startAfterDocument(lastEventDoc)
            .limit(2)
            .get();
      }

      debugPrint(
          'getEventsWomanDone : Event documents fetched. Converting to Event objects...');
      List<Future<Event?>> futureEvents =
          eventSnap.docs.map((doc) => Event.fromDocument(doc)).toList();

      // Use Future.wait to resolve all events
      List<Event?> events = await Future.wait(futureEvents);

      debugPrint(
          'getEventsWomanDone : Event objects created. Total events: ${events.length}');
      // Here, you might also debugPrint an event for debugging
      if (events.isNotEmpty) {
        debugPrint('getEventsWomanDone : First event details: ${events.first}');
      }

      return events;
    } catch (e) {
      debugPrint(
          'getEventsWomanDone : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<List<Event?>> getEventsDoneByUserId({
    required String userId,
    String? lastEventId,
  }) async {
    try {
      debugPrint(
          'getEventsDoneByUserId : Attempting to fetch event documents from Firestore for Brand : $userId ...');

      // Créer une référence à un document utilisateur
      DocumentReference userRef =
          _firebaseFirestore.collection(Paths.users).doc(userId);

      QuerySnapshot eventSnap;
      if (lastEventId == null) {
        // Initial fetch
        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .where('user_ref', isEqualTo: userRef) // Ajouter cette ligne
            .orderBy('dateEvent', descending: true)
            .limit(100)
            .get();
      } else {
        // Pagination fetch
        final lastEventDoc = await _firebaseFirestore
            .collection(Paths.events)
            .doc(lastEventId)
            .get();

        if (!lastEventDoc.exists) {
          debugPrint(
              'getEventsDoneByUserId : Last event document does not exist.');
          return [];
        }

        eventSnap = await _firebaseFirestore
            .collection(Paths.events)
            .where('done', isEqualTo: true)
            .where('user_ref', isEqualTo: userRef) // Ajouter cette ligne
            .orderBy('dateEvent', descending: true)
            .startAfterDocument(lastEventDoc)
            .limit(2)
            .get();
      }

      debugPrint(
          'getEventsDoneByUserId : Event documents fetched. Converting to Event objects...');
      List<Future<Event?>> futureEvents =
          eventSnap.docs.map((doc) => Event.fromDocument(doc)).toList();

      // Use Future.wait to resolve all events
      List<Event?> events = await Future.wait(futureEvents);

      debugPrint(
          'getEventsDoneByUserId : Event objects created. Total events: ${events.length}');
      // Here, you might also debugPrint an event for debugging
      if (events.isNotEmpty) {
        debugPrint(
            'getEventsDoneByUserId : First event details: ${events.first}');
      }

      return events;
    } catch (e) {
      debugPrint(
          'getEventsDoneByUserId : An error occurred while fetching events: ${e.toString()}');
      return [];
    }
  }

  Future<List<Event>> getThisWeekEvents() async {
    List<Event> eventsList = [];
    try {
      debugPrint(
          'getThisWeekEvents: Attempting to fetch events from Firestore for the current week.');

      DateTime now = DateTime.now();
      DateTime oneWeekFromNow = now.add(const Duration(days: 7));

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
        debugPrint('getThisWeekEvents: Events fetched successfully.');
      } else {
        debugPrint('getThisWeekEvents: No events found for the current week.');
      }
    } catch (e) {
      debugPrint(
          'getThisWeekEvents: Error occurred while fetching events - $e');
    }
    return eventsList;
  }

  Future<List<Event>> getComingSoonEvents() async {
    List<Event> eventsList = [];
    try {
      debugPrint(
          'getComingSoonEvents: Attempting to fetch future events from Firestore.');

      DateTime now = DateTime.now();
      DateTime oneWeekFromNow = now.add(const Duration(days: 7));

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
        debugPrint('getComingSoonEvents: Future events fetched successfully.');
      } else {
        debugPrint('getComingSoonEvents: No future events found.');
      }
    } catch (e) {
      debugPrint(
          'getComingSoonEvents: Error occurred while fetching future events - $e');
    }
    return eventsList;
  }

  Stream<List<Future<Comment?>>> getEventComments({required String eventId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(eventId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

  Future<void> createComment({
    required CommentEvent comment,
  }) async {
    debugPrint('createComment : Début de la méthode createComment');

    debugPrint('createComment : Ajout du commentaire dans Firestore');
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.eventId)
        .collection(Paths.postComments)
        .add(comment.toDocument())
        .then(
            (_) => debugPrint('createComment : Commentaire ajouté avec succès'))
        .catchError((e) => debugPrint(
            'createComment : Erreur lors de l\'ajout du commentaire: $e'));
    debugPrint('createComment : Fin de la méthode createComment');
  }
}
