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
  final String location;
  final int followers;
  final int following;
  final String bio;

  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
    required this.location,
    required this.followers,
    required this.following,
    required this.bio,
  });

  static const empty = User(
    id: '',
    username: '',
    firstName: '',
    lastName: '',
    email: '',
    profileImageUrl: '',
    location: '',
    followers: 0,
    following: 0,
    bio: '',
  );

  @override
  List<Object?> get props => [
        id,
        username,
        firstName,
        lastName,
        email,
        profileImageUrl,
        location,
        followers,
        following,
        bio,
      ];

  User copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImageUrl,
    String? location,
    int? followers,
    int? following,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
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
      'location': location,
      'followers': followers,
      'following': following,
      'bio': bio,
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
      location: snap.data().toString().contains('location')
          ? snap.get('location')
          : '',
      followers: snap.data().toString().contains('followers')
          ? snap.get('followers')
          : 0,
      following: snap.data().toString().contains('following')
          ? snap.get('following')
          : 0,
      bio: snap.data().toString().contains('bio') ? snap.get('bio') : '',
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
      location: data['location'] ?? '',
      followers: (data['followers'] ?? 0).toInt(),
      following: (data['following'] ?? 0).toInt(),
      bio: data['bio'] ?? '',
    );
  }
}
