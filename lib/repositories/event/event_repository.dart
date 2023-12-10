import 'package:bootdv2/config/configs.dart';
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
          debugPrint('getEventsDone : Last event document does not exist.');
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
}
