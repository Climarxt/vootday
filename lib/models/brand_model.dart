import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String? id;
  final String author;
  final String logoUrl;

  const Brand({
    this.id,
    required this.author,
    required this.logoUrl,
  });

  @override
  List<Object?> get props => [id, author, logoUrl];

  static const empty = Brand(
    id: '', // Un identifiant vide
    author: '', // Un auteur fictif ou vide
    logoUrl: '', // Une URL de logo fictive ou vide
  );

  Brand copyWith({
    String? id,
    String? author,
    String? logoUrl,
  }) {
    return Brand(
      id: id ?? this.id,
      author: author ?? this.author,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author': author,
      'logoUrl': logoUrl,
    };
  }

  static Brand fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Brand(
      author: data['author'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
    );
  }

  static Brand fromSnapshot(DocumentSnapshot snap) {
    Brand user = Brand(
      id: snap.id,
      author:
          snap.data().toString().contains('author') ? snap.get('author') : '',
      logoUrl:
          snap.data().toString().contains('logoUrl') ? snap.get('logoUrl') : '',
    );
    return user;
  }

  get() {}
}
