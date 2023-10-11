import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String description;
  final String title;
  final String uid;
  final String username;
  final String eventId;
  final datePublished;
  final String eventUrl;
  final String profImage;
  final dateEvent;
  final String reward;

  const Event(
      {required this.description,
      required this.title,
      required this.uid,
      required this.username,
      required this.eventId,
      required this.datePublished,
      required this.eventUrl,
      required this.profImage,
      required this.dateEvent,
      required this.reward});

  Map<String, dynamic> toJson() => {
        "description": description,
        "title": title,
        "uid": uid,
        "username": username,
        "eventId": eventId,
        "datePublished": datePublished,
        "eventUrl": eventUrl,
        "profImage": profImage,
        "dateEvent": dateEvent,
        "reward": reward,
      };

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "title": title,
      "uid": uid,
      "username": username,
      "eventId": eventId,
      "datePublished": datePublished,
      "eventUrl": eventUrl,
      "profImage": profImage,
      "dateEvent": dateEvent,
      "reward": reward,
    };
  }

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Event(
      description: snapshot['description'],
      title: snapshot['title'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      eventId: snapshot['eventId'],
      datePublished: snapshot['datePublished'],
      eventUrl: snapshot['eventUrl'],
      profImage: snapshot['profImage'],
      dateEvent: snapshot['dateEvent'],
      reward: snapshot['reward'],
    );
  }

  factory Event.fromDS(String id, Map<String, dynamic> data) {
    return Event(
      description: data['description'],
      title: data['title'],
      uid: data['uid'],
      username: data['username'],
      eventId: data['eventId'],
      datePublished: data['datePublished'],
      eventUrl: data['eventUrl'],
      profImage: data['profImage'],
      dateEvent: data['dateEvent'],
      reward: data['reward'],
    );
  }
}
