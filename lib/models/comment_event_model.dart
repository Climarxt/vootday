import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEvent extends Equatable {
  final String? id;
  final String eventId;
  final User author;
  final String content;
  final DateTime date;

  const CommentEvent({
    this.id,
    required this.eventId,
    required this.author,
    required this.content,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        eventId,
        author,
        content,
        date,
      ];

  CommentEvent copyWith({
    String? id,
    String? eventId,
    User? author,
    String? content,
    DateTime? date,
  }) {
    return CommentEvent(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'eventId': eventId,
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'content': content,
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<CommentEvent?> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final authorRef = data['author'] as DocumentReference?;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return CommentEvent(
          id: doc.id,
          eventId: data['eventId'] ?? '',
          author: User.fromSnapshot(authorDoc),
          content: data['content'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }
}
