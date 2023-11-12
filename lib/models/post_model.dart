import 'package:cached_network_image/cached_network_image.dart';
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

  static var empty = Post(
    id: '',
    imageUrl: '',
    author: User.empty,
    thumbnailUrl: '',
    caption: '',
    likes: 0,
    date: DateTime(0),
    tags: [],

  );

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

  CachedNetworkImageProvider get imageProvider {
    return CachedNetworkImageProvider(imageUrl);
  }

  static Future<Post?> fromDocument(DocumentSnapshot doc) async {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        return null;
      }

      final authorRef = data['author'] as DocumentReference?;
      if (authorRef != null) {
        final authorDoc = await authorRef.get();
        if (authorDoc.exists) {
          // Create and return the Post instance
          return Post(
            id: doc.id,
            author: User.fromSnapshot(authorDoc),
            imageUrl: data['imageUrl'] ?? '',
            thumbnailUrl: data['thumbnailUrl'] ?? '',
            caption: data['caption'] ?? '',
            likes: (data['likes'] ?? 0).toInt(),
            date: (data['date'] as Timestamp).toDate(),
            tags: (data['tags'] as List).map((item) => item as String).toList(),
          );
        } else {
          print(
              'Class POST fromDocument : Author document does not exist for doc ID: ${doc.id}');
        }
      } else {
        print(
            'Class POST fromDocument : Author reference is null for doc ID: ${doc.id}');
      }
    } catch (e) {
      print(
          'Class POST fromDocument : Error in fromDocument for doc ID: ${doc.id}: $e');
    }

    return null;
  }
}
