// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String? id;
  final String author;
  final String author_lowercase;
  final String logoUrl;

  const Brand({
    this.id,
    required this.author,
    required this.author_lowercase,
    required this.logoUrl,
  });

  @override
  List<Object?> get props => [id, author, logoUrl];

  static const empty = Brand(
    id: '', // Un identifiant vide
    author: '', // Un auteur fictif ou vide
    author_lowercase: '',
    logoUrl: '', // Une URL de logo fictive ou vide
  );

  Brand copyWith({
    String? id,
    String? author,
    String? author_lowercase,
    String? logoUrl,
  }) {
    return Brand(
      id: id ?? this.id,
      author: author ?? this.author,
      author_lowercase: author_lowercase ?? this.author_lowercase,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author': author,
      'author_lowercase': author_lowercase,
      'logoUrl': logoUrl,
    };
  }

  static Brand fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Brand(
      author: data['author'] ?? '',
      author_lowercase: data['author_lowercase'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
    );
  }

  static Brand fromSnapshot(DocumentSnapshot snap) {
    Brand user = Brand(
      id: snap.id,
      author:
          snap.data().toString().contains('author') ? snap.get('author') : '',
      author_lowercase:
          snap.data().toString().contains('author_lowercase') ? snap.get('author_lowercase') : '',
      logoUrl:
          snap.data().toString().contains('logoUrl') ? snap.get('logoUrl') : '',
    );
    return user;
  }

  get() {}
}
