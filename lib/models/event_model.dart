// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:bootdv2/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final Brand author;
  final String imageUrl;
  final String caption;
  final int participants;
  final String title;
  final DateTime date;
  final DateTime dateEvent;
  final List<String> tags;
  final String reward;
  final bool done;

  const Event({
    this.id,
    required this.author,
    required this.imageUrl,
    required this.caption,
    required this.participants,
    required this.title,
    required this.date,
    required this.dateEvent,
    required this.tags,
    required this.reward,
    this.done = false,
  });

  List<Object?> get props => [
        id,
        author,
        imageUrl,
        caption,
        participants,
        title,
        date,
        dateEvent,
        tags,
        reward,
        done,
      ];

  CachedNetworkImageProvider get imageProvider {
    return CachedNetworkImageProvider(imageUrl);
  }

  Map<String, dynamic> toDocument() {
    return {
      'author': FirebaseFirestore.instance.collection('brands').doc(author.id),
      'imageUrl': imageUrl,
      'caption': caption,
      'participants': participants,
      'title': title,
      'date': Timestamp.fromDate(date),
      'dateEvent': Timestamp.fromDate(dateEvent),
      'tags': tags,
      'reward': reward,
      'done': done,
    };
  }

  static Future<Event?> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final authorRef = data['author'] as DocumentReference?;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Event(
          id: doc.id,
          author: Brand.fromSnapshot(authorDoc),
          imageUrl: data['imageUrl'] ?? '',
          caption: data['caption'] ?? '',
          participants: (data['participants'] ?? 0).toInt(),
          title: data['title'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          dateEvent: (data['dateEvent'] as Timestamp).toDate(),
          tags: (data['tags'] as List).map((item) => item as String).toList(),
          reward: data['reward'] ?? '',
          done: (data['done'] ?? false) as bool,
        );
      }
    }
    return null;
  }
}
