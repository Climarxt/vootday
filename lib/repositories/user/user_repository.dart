import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../config/configs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<User>> getUserFollowers({
    required String userId,
  }) async {
    try {
      debugPrint(
          'getUserFollowers : Attempting to fetch user followers from Firestore...');

      // Récupérer les documents de la sous-collection 'userFollowers'
      QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
          .collection('followers')
          .doc(userId)
          .collection('userFollowers')
          .get();

      debugPrint('getUserFollowers : Followers documents fetched.');

      // Créer une liste pour les futures informations des utilisateurs
      List<Future<User?>> futureUsers = followersSnapshot.docs.map((doc) async {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .get();
        return userDoc.exists ? User.fromDocument(userDoc) : null;
      }).toList();

      // Résoudre tous les futures pour obtenir les informations détaillées des utilisateurs
      List<User> followers =
          (await Future.wait(futureUsers)).whereType<User>().toList();

      debugPrint(
          'getUserFollowers : User objects created. Total followers: ${followers.length}');

      return followers;
    } catch (e) {
      debugPrint(
          'getUserFollowers : An error occurred while fetching followers: ${e.toString()}');
      return [];
    }
  }

  Future<List<User>> getUserFollowing({
    required String userId,
  }) async {
    try {
      debugPrint(
          'getUserFollowing : Attempting to fetch user followers from Firestore...');

      // Récupérer les documents de la sous-collection 'userFollowing'
      QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(userId)
          .collection('userFollowing')
          .get();

      debugPrint('getUserFollowing : Followers documents fetched.');

      // Créer une liste pour les futures informations des utilisateurs
      List<Future<User?>> futureUsers = followersSnapshot.docs.map((doc) async {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .get();
        return userDoc.exists ? User.fromDocument(userDoc) : null;
      }).toList();

      // Résoudre tous les futures pour obtenir les informations détaillées des utilisateurs
      List<User> followers =
          (await Future.wait(futureUsers)).whereType<User>().toList();

      debugPrint(
          'getUserFollowing : User objects created. Total followers: ${followers.length}');

      return followers;
    } catch (e) {
      debugPrint(
          'getUserFollowing : An error occurred while fetching followers: ${e.toString()}');
      return [];
    }
  }

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Future<void> updateUser({required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({required String query}) async {
    // Convertir la requête en minuscules
    String lowerCaseQuery = query.toLowerCase();

    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username_lowercase', isGreaterThanOrEqualTo: lowerCaseQuery)
        .where('username_lowercase', isLessThan: '$lowerCaseQuery\uf8ff')
        .get();

    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void followUser({
    required String userId,
    required String followUserId,
  }) {
    // Add followUser to user's userFollowing.
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followUserId)
        .set({});
    // Add user to followUser's userFollowers.
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(followUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});

    final notification = Notif(
      type: NotifType.follow,
      fromUser: User.empty.copyWith(id: userId),
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(followUserId)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  @override
  void unfollowUser({
    required String userId,
    required String unfollowUserId,
  }) {
    // Remove unfollowUser from user's userFollowing.
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId)
        .delete();
    // Remove user from unfollowUser's userFollowers.
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .delete();
  }

  @override
  Future<bool> isFollowing({
    required String userId,
    required String otherUserId,
  }) async {
    // is otherUser in user's userFollowing
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }
}
