import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../config/configs.dart';

import '/models/models.dart';

class Post extends Equatable {
  final String? id;
  final User author;
  final String imageUrl;
  final String thumbnailUrl;
  final String caption;
  final int likes;
  final DateTime date;
  final List<String> tags; // Add tags attribute

  const Post({
    this.id,
    required this.author,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.likes,
    required this.date,
    required this.tags, // Make tags required
  });

  @override
  List<Object?> get props => [
        id,
        author,
        imageUrl,
        thumbnailUrl,
        caption,
        likes,
        date,
        tags, // Include tags in props
      ];

  Post copyWith({
    String? id,
    User? author,
    String? imageUrl,
    String? thumbnailUrl,
    String? caption,
    int? likes,
    DateTime? date,
    List<String>? tags, // Add tags to copyWith
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      date: date ?? this.date,
      tags: tags ?? this.tags, // Assign tags in copyWith
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'likes': likes,
      'date': Timestamp.fromDate(date),
      'tags': tags, // Include tags in the document map
    };
  }

  static Future<Post?> fromDocument(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final authorRef = data['author'] as DocumentReference?;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Post(
          id: doc.id,
          author: User.fromSnapshot(authorDoc),
          imageUrl: data['imageUrl'] ?? '',
          thumbnailUrl: data['thumbnailUrl'] ?? '',
          caption: data['caption'] ?? '',
          likes: (data['likes'] ?? 0).toInt(),
          date: (data['date'] as Timestamp).toDate(),
          tags: (data['tags'] as List)
              .map((item) => item as String)
              .toList(), // Parse tags from the document
        );
      }
    }
    return null;
  }
}
