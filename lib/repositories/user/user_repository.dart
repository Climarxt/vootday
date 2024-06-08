import 'package:bootdv2/config/logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/configs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('UserRepository');

  Future<List<User>> getUserFollowers({
    required String userId,
  }) async {
    const String functionName = 'getUserFollowers';
    try {
      logger.logInfo(
          functionName,
          'Attempting to fetch user followers from Firestore...',
          {'userId': userId});

      // Récupérer les documents de la sous-collection 'userFollowers'
      QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
          .collection('followers')
          .doc(userId)
          .collection('userFollowers')
          .get();

      logger.logInfo(
          functionName, 'Followers documents fetched.', {'userId': userId});

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

      logger.logInfo(functionName, 'User objects created.',
          {'totalFollowers': followers.length});

      return followers;
    } catch (e) {
      logger.logError(
          functionName,
          'An error occurred while fetching followers.',
          {'userId': userId, 'error': e.toString()});
      return [];
    }
  }

  Future<List<User>> getUserFollowing({
    required String userId,
  }) async {
    const String functionName = 'getUserFollowing';
    try {
      logger.logInfo(
          functionName,
          'Attempting to fetch user following from Firestore...',
          {'userId': userId});

      // Récupérer les documents de la sous-collection 'userFollowing'
      QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(userId)
          .collection('userFollowing')
          .get();

      logger.logInfo(
          functionName, 'Following documents fetched.', {'userId': userId});

      // Créer une liste pour les futures informations des utilisateurs
      List<Future<User?>> futureUsers = followingSnapshot.docs.map((doc) async {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .get();
        return userDoc.exists ? User.fromDocument(userDoc) : null;
      }).toList();

      // Résoudre tous les futures pour obtenir les informations détaillées des utilisateurs
      List<User> following =
          (await Future.wait(futureUsers)).whereType<User>().toList();

      logger.logInfo(functionName, 'User objects created.',
          {'totalFollowing': following.length});

      return following;
    } catch (e) {
      logger.logError(
          functionName,
          'An error occurred while fetching following.',
          {'userId': userId, 'error': e.toString()});
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
    const String functionName = 'updateUser';
    try {
      await _firebaseFirestore
          .collection(Paths.users)
          .doc(user.id)
          .update(user.toDocument());
      logger.logInfo(
          functionName, 'User updated successfully.', {'userId': user.id});
    } catch (e) {
      logger.logError(functionName, 'An error occurred while updating user.',
          {'userId': user.id, 'error': e.toString()});
    }
  }

  @override
  Future<List<User>> searchUsers({required String query}) async {
    const String functionName = 'searchUsers';
    try {
      // Convertir la requête en minuscules
      String lowerCaseQuery = query.toLowerCase();

      final userSnap = await _firebaseFirestore
          .collection(Paths.users)
          .where('username_lowercase', isGreaterThanOrEqualTo: lowerCaseQuery)
          .where('username_lowercase', isLessThan: '$lowerCaseQuery\uf8ff')
          .get();

      List<User> users =
          userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
      logger.logInfo(functionName, 'Users search completed.',
          {'query': query, 'results': users.length});
      return users;
    } catch (e) {
      logger.logError(functionName, 'An error occurred while searching users.',
          {'query': query, 'error': e.toString()});
      return [];
    }
  }

  @override
  void followUser({
    required String userId,
    required String followUserId,
  }) {
    const String functionName = 'followUser';
    try {
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
      logger.logInfo(functionName, 'User followed successfully.',
          {'userId': userId, 'followUserId': followUserId});
    } catch (e) {
      logger.logError(functionName, 'An error occurred while following user.', {
        'userId': userId,
        'followUserId': followUserId,
        'error': e.toString()
      });
    }
  }

  @override
  void unfollowUser({
    required String userId,
    required String unfollowUserId,
  }) {
    const String functionName = 'unfollowUser';
    try {
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
      logger.logInfo(functionName, 'User unfollowed successfully.',
          {'userId': userId, 'unfollowUserId': unfollowUserId});
    } catch (e) {
      logger.logError(
          functionName, 'An error occurred while unfollowing user.', {
        'userId': userId,
        'unfollowUserId': unfollowUserId,
        'error': e.toString()
      });
    }
  }

  @override
  Future<bool> isFollowing({
    required String userId,
    required String otherUserId,
  }) async {
    const String functionName = 'isFollowing';
    try {
      // is otherUser in user's userFollowing
      final otherUserDoc = await _firebaseFirestore
          .collection(Paths.following)
          .doc(userId)
          .collection(Paths.userFollowing)
          .doc(otherUserId)
          .get();
      bool isFollowing = otherUserDoc.exists;
      logger.logInfo(functionName, 'Follow status checked.', {
        'userId': userId,
        'otherUserId': otherUserId,
        'isFollowing': isFollowing
      });
      return isFollowing;
    } catch (e) {
      logger.logError(
          functionName, 'An error occurred while checking follow status.', {
        'userId': userId,
        'otherUserId': otherUserId,
        'error': e.toString()
      });
      return false;
    }
  }

  // Ajout d'une méthode pour récupérer les détails d'un utilisateur
  Future<User> fetchUserDetails(String userId) async {
    const String functionName = 'fetchUserDetails';
    try {
      DocumentSnapshot userDoc =
          await _firebaseFirestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        logger
            .logInfo(functionName, 'User details fetched.', {'userId': userId});
        return User.fromDocument(userDoc);
      } else {
        throw Exception("User not found!");
      }
    } catch (e) {
      logger.logError(
          functionName,
          'An error occurred while fetching user details.',
          {'userId': userId, 'error': e.toString()});
      rethrow;
    }
  }
}
