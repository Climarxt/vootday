// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String profileImageUrl;
  final String locationCity;
  final String locationState;
  final String locationCountry;
  final int followers;
  final int following;
  final String bio;
  final String selectedGender;
  final String username_lowercase;
  final String socialInstagram;
  final String socialTiktok;

  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
    required this.locationCity,
    required this.locationState,
    required this.locationCountry,
    required this.followers,
    required this.following,
    required this.bio,
    required this.selectedGender,
    required this.username_lowercase,
    required this.socialInstagram,
    required this.socialTiktok,
  });

  static const empty = User(
    id: '',
    username: '',
    firstName: '',
    lastName: '',
    email: '',
    profileImageUrl: '',
    locationCity: '',
    locationState: '',
    locationCountry: '',
    followers: 0,
    following: 0,
    bio: '',
    selectedGender: '',
    username_lowercase: '',
    socialInstagram: '',
    socialTiktok: '',
  );

  @override
  List<Object?> get props => [
        id,
        username,
        firstName,
        lastName,
        email,
        profileImageUrl,
        locationCity,
        locationState,
        locationCountry,
        followers,
        following,
        bio,
        selectedGender,
        username_lowercase,
        socialInstagram,
        socialTiktok,
      ];

  User copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImageUrl,
    String? locationCity,
    String? locationState,
    String? locationCountry,
    int? followers,
    int? following,
    String? bio,
    String? selectedGender,
    String? username_lowercase,
    String? socialInstagram,
    String? socialTiktok,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      locationCity: locationCity ?? this.locationCity,
      locationState: locationState ?? this.locationState,
      locationCountry: locationCountry ?? this.locationCountry,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
      selectedGender: selectedGender ?? this.selectedGender,
      username_lowercase: username_lowercase ?? this.username_lowercase,
      socialInstagram: socialInstagram ?? this.socialInstagram,
      socialTiktok: socialTiktok ?? this.socialTiktok,
    );
  }

// User model to json for Firebase
  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'locationCity': locationCity,
      'locationState': locationState,
      'locationCountry': locationCountry,
      'followers': followers,
      'following': following,
      'bio': bio,
      'selectedGender': selectedGender,
      'username_lowercase': username_lowercase,
      'socialInstagram': socialInstagram,
      'socialTiktok': socialTiktok,
    };
  }

  CachedNetworkImageProvider get profileImageProvider {
    return CachedNetworkImageProvider(profileImageUrl);
  }

  static User fromSnapshot(DocumentSnapshot snap) {
    User user = User(
      id: snap.id,
      username: snap.data().toString().contains('username')
          ? snap.get('username')
          : '',
      firstName: snap.data().toString().contains('firstName')
          ? snap.get('firstName')
          : '',
      lastName: snap.data().toString().contains('lastName')
          ? snap.get('lastName')
          : '',
      email: snap.data().toString().contains('email') ? snap.get('email') : '',
      profileImageUrl: snap.data().toString().contains('profileImageUrl')
          ? snap.get('profileImageUrl')
          : '',
      locationCity: snap.data().toString().contains('locationCity')
          ? snap.get('locationCity')
          : '',
      locationState: snap.data().toString().contains('locationState')
          ? snap.get('locationState')
          : '',
      locationCountry: snap.data().toString().contains('locationCountry')
          ? snap.get('locationCountry')
          : '',
      followers: snap.data().toString().contains('followers')
          ? snap.get('followers')
          : 0,
      following: snap.data().toString().contains('following')
          ? snap.get('following')
          : 0,
      bio: snap.data().toString().contains('bio') ? snap.get('bio') : '',
      selectedGender: snap.data().toString().contains('selectedGender')
          ? snap.get('selectedGender')
          : '',
      username_lowercase: snap.data().toString().contains('username_lowercase')
          ? snap.get('username_lowercase')
          : '',
      socialInstagram: snap.data().toString().contains('socialInstagram')
          ? snap.get('socialInstagram')
          : '',
      socialTiktok: snap.data().toString().contains('socialTiktok')
          ? snap.get('socialTiktok')
          : '',
    );
    return user;
  }

// User model from Firebase
  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      locationCity: data['locationCity'] ?? '',
      locationState: data['locationState'] ?? '',
      locationCountry: data['locationCountry'] ?? '',
      followers: (data['followers'] ?? 0).toInt(),
      following: (data['following'] ?? 0).toInt(),
      bio: data['bio'] ?? '',
      selectedGender: data['selectedGender'] ?? '',
      username_lowercase: data['username_lowercase'] ?? '',
      socialInstagram: data['socialInstagram'] ?? '',
      socialTiktok: data['socialTiktok'] ?? '',
    );
  }
}
