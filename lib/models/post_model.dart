// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Post extends Equatable {
  final String? id;
  final User author;
  final String imageUrl;
  final String thumbnailUrl;
  final String caption;
  final int likes;
  final DateTime date;
  final List<String> tags;
  final String selectedGender;
  final String locationCity;
  final String locationState;
  final String locationCountry;
  final String locationSelected;

  const Post({
    this.id,
    required this.author,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.likes,
    required this.date,
    required this.tags,
    required this.selectedGender,
    required this.locationCity,
    required this.locationState,
    required this.locationCountry,
    required this.locationSelected,
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
    selectedGender: '',
    locationCity: '',
    locationState: '',
    locationCountry: '',
    locationSelected: '',
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
        tags,
        selectedGender,
        locationCity,
        locationState,
        locationCountry,
        locationSelected,
      ];

  Post copyWith({
    String? id,
    User? author,
    String? imageUrl,
    String? thumbnailUrl,
    String? caption,
    int? likes,
    DateTime? date,
    List<String>? tags,
    String? selectedGender,
    String? locationCity,
    String? locationState,
    String? locationCountry,
    String? locationSelected,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      selectedGender: selectedGender ?? this.selectedGender,
      locationCity: locationCity ?? this.locationCity,
      locationState: locationState ?? this.locationState,
      locationCountry: locationCountry ?? this.locationCountry,
      locationSelected: locationSelected ?? this.locationSelected,
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
      'tags': tags,
      'selectedGender': selectedGender,
      'locationCity': locationCity,
      'locationState': locationState,
      'locationCountry': locationCountry,
      'locationSelected': locationCountry,
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
            selectedGender: data['selectedGender'] ?? '',
            locationCity: data['locationCity'] ?? '',
            locationState: data['locationState'] ?? '',
            locationCountry: data['locationCountry'] ?? '',
            locationSelected: data['locationSelected'] ?? '',
          );
        } else {
          debugPrint(
              'Class POST fromDocument : Author document does not exist for doc ID: ${doc.id}');
        }
      } else {
        debugPrint(
            'Class POST fromDocument : Author reference is null for doc ID: ${doc.id}');
      }
    } catch (e) {
      debugPrint(
          'Class POST fromDocument : Error in fromDocument for doc ID: ${doc.id}: $e');
    }

    return null;
  }
}
