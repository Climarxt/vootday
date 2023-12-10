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
}
