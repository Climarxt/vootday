import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  final String? id;
  final User author;
  final DateTime date;
  final String name;

  const Collection({
    required this.id,
    required this.author,
    required this.date,
    required this.name,
  });

  static var empty = Collection(
    id: '',
    author: User.empty,
    date: DateTime(0),
    name: '',
  );

  List<Object?> get props => [id, author, date, name];

  Collection copyWith({
    String? id,
    User? author,
    DateTime? date,
    String? name,
  }) {
    return Collection(
      id: id ?? this.id,
      author: author ?? this.author,
      date: date ?? this.date,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'date': date,
      'name': name,
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
            name: data['name'] as String,
          );
        } else {
          print(
              'Class COLLECTION fromDocument : Author document does not exist for doc ID: ${doc.id}');
        }
      } else {
        print(
            'Class COLLECTION fromDocument : Author reference is null for doc ID: ${doc.id}');
      }
    } catch (e) {
      print(
          'Class COLLECTION fromDocument : Error in fromDocument for doc ID: ${doc.id}: $e');
    }

    return null;
  }
}
