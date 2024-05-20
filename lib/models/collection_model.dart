import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Collection extends Equatable {
  final String id;
  final User author;
  final DateTime date;
  final String title;
  final bool public;

  const Collection({
    required this.id,
    required this.author,
    required this.date,
    required this.title,
    required this.public,
  });

  static var empty = Collection(
    id: '',
    author: User.empty,
    date: DateTime(0),
    title: '',
    public: true,
  );

  @override
  List<Object?> get props => [id, author, date, title, public];

  Collection copyWith({
    String? id,
    User? author,
    DateTime? date,
    String? title,
    bool? public
  }) {
    return Collection(
      id: id ?? this.id,
      author: author ?? this.author,
      date: date ?? this.date,
      title: title ?? this.title,
      public: public ?? this.public
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'date': date,
      'title': title,
      'public': public
    };
  }

  static Future<Collection?> fromDocument(DocumentSnapshot doc) async {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        return null;
      }

      final authorRef = data['author'] as DocumentReference?;
      if (authorRef != null) {
        final authorDoc = await authorRef.get();
        if (authorDoc.exists) {
          return Collection(
            id: doc.id,
            author: User.fromSnapshot(authorDoc),
            date: (data['date'] as Timestamp).toDate(),
            title: data['title'] as String,
            public: data['public'] as bool,
          );
        } else {
          debugPrint(
              'Class COLLECTION fromDocument : Author document does not exist for doc ID: ${doc.id}');
        }
      } else {
        debugPrint(
            'Class COLLECTION fromDocument : Author reference is null for doc ID: ${doc.id}');
      }
    } catch (e) {
      debugPrint(
          'Class COLLECTION fromDocument : Error in fromDocument for doc ID: ${doc.id}: $e');
    }

    return null;
  }
}
