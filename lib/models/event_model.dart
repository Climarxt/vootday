// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:bootdv2/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final Brand author;
  final String imageUrl;
  final String caption;
  final int participants;
  final String title;
  final DateTime date;
  final DateTime dateEvent;
  final DateTime dateEnd;
  final List<String> tags;
  final String reward;
  final bool done;
  final String logoUrl;

  const Event({
    required this.id,
    required this.author,
    required this.imageUrl,
    required this.caption,
    required this.participants,
    required this.title,
    required this.date,
    required this.dateEvent,
    required this.dateEnd,
    required this.tags,
    required this.reward,
    this.done = false,
    required this.logoUrl,
  });

  static var empty = Event(
    id: '',
    author: Brand.empty, // Assuming you have an empty constructor for Brand
    imageUrl: '',
    caption: '',
    participants: 0,
    title: '',
    date: DateTime(0),
    dateEvent: DateTime(0),
    dateEnd: DateTime(0),
    tags: [],
    reward: '',
    done: false,
    logoUrl: '',
  );

  List<Object?> get props => [
        id,
        author,
        imageUrl,
        caption,
        participants,
        title,
        date,
        dateEvent,
        dateEnd,
        tags,
        reward,
        done,
        logoUrl
      ];

  Event copyWith({
    String? id,
    Brand? author,
    String? imageUrl,
    String? caption,
    int? participants,
    String? title,
    DateTime? date,
    DateTime? dateEvent,
    DateTime? dateEnd,
    List<String>? tags,
    String? reward,
    bool? done,
    String? logoUrl,
  }) {
    return Event(
      id: id ?? this.id,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      participants: participants ?? this.participants,
      title: title ?? this.title,
      date: date ?? this.date,
      dateEvent: dateEvent ?? this.dateEvent,
      dateEnd: dateEnd ?? this.dateEnd,
      tags: tags ?? this.tags,
      reward: reward ?? this.reward,
      done: done ?? this.done,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

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
      'dateEnd': Timestamp.fromDate(dateEnd),
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
        Brand author = Brand.fromSnapshot(authorDoc);
        return Event(
          id: doc.id,
          author: Brand.fromSnapshot(authorDoc),
          imageUrl: data['imageUrl'] ?? '',
          caption: data['caption'] ?? '',
          participants: (data['participants'] ?? 0).toInt(),
          title: data['title'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          dateEvent: (data['dateEvent'] as Timestamp).toDate(),
          dateEnd: (data['dateEnd'] as Timestamp).toDate(),
          tags: (data['tags'] as List).map((item) => item as String).toList(),
          reward: data['reward'] ?? '',
          done: (data['done'] ?? false) as bool,
          logoUrl: author.logoUrl,
        );
      }
    }
    return null;
  }
}
