import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String? id;
  final String name;
  final String logoUrl;

  const Brand({
    this.id,
    required this.name,
    required this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, logoUrl];

  Brand copyWith({
    String? id,
    String? name,
    String? logoUrl,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'logoUrl': logoUrl,
    };
  }

  static Brand fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Brand(
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
    );
  }
}
