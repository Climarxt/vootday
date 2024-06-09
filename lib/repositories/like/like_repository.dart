import 'package:bootdv2/config/configs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/config/logger/logger.dart';

class LikeRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  LikeRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('LikeRepository');

  Future<void> createLike({
    required Post post,
    required String userId,
  }) async {
    const String functionName = 'createLike';
    try {
      logger.logInfo(functionName, 'Creating like', {
        'postId': post.id,
        'userId': userId,
      });

      await _firebaseFirestore
          .collection(Paths.posts)
          .doc(post.id)
          .update({'likes': FieldValue.increment(1)});

      await _firebaseFirestore
          .collection(Paths.likes)
          .doc(post.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .set({});

      final notification = Notif(
        type: NotifType.like,
        fromUser: User.empty.copyWith(id: userId),
        post: post,
        date: DateTime.now(),
      );

      await _firebaseFirestore
          .collection(Paths.notifications)
          .doc(post.author.id)
          .collection(Paths.userNotifications)
          .add(notification.toDocument());

      logger
          .logInfo(functionName, 'Like and notification created successfully', {
        'postId': post.id,
        'userId': userId,
      });
    } catch (e) {
      logger.logError(functionName, 'Error creating like or notification', {
        'postId': post.id,
        'userId': userId,
        'error': e.toString(),
      });
      throw e;
    }
  }

  Future<Set<String>> getLikedPostIds({
    required String userId,
    required List<Post?> posts,
  }) async {
    const String functionName = 'getLikedPostIds';
    final postIds = <String>{};
    try {
      logger
          .logInfo(functionName, 'Fetching liked post IDs', {'userId': userId});
      for (final post in posts) {
        final likeDoc = await _firebaseFirestore
            .collection(Paths.likes)
            .doc(post!.id)
            .collection(Paths.postLikes)
            .doc(userId)
            .get();
        if (likeDoc.exists) {
          postIds.add(post.id!);
        }
      }
      logger.logInfo(functionName, 'Fetched liked post IDs successfully', {
        'userId': userId,
        'likedPostCount': postIds.length,
      });
      return postIds;
    } catch (e) {
      logger.logError(functionName, 'Error fetching liked post IDs', {
        'userId': userId,
        'error': e.toString(),
      });
      throw e;
    }
  }

  Future<void> deleteLike(
      {required String postId, required String userId}) async {
    const String functionName = 'deleteLike';
    try {
      logger.logInfo(functionName, 'Deleting like', {
        'postId': postId,
        'userId': userId,
      });

      await _firebaseFirestore
          .collection(Paths.posts)
          .doc(postId)
          .update({'likes': FieldValue.increment(-1)});

      await _firebaseFirestore
          .collection(Paths.likes)
          .doc(postId)
          .collection(Paths.postLikes)
          .doc(userId)
          .delete();

      logger.logInfo(functionName, 'Like deleted successfully', {
        'postId': postId,
        'userId': userId,
      });
    } catch (e) {
      logger.logError(functionName, 'Error deleting like', {
        'postId': postId,
        'userId': userId,
        'error': e.toString(),
      });
      throw e;
    }
  }

  Future<bool> isPostInLikes({
    required String postId,
    required String userIdfromPost,
    required String userIdfromAuth,
  }) async {
    const String functionName = 'isPostInLikes';
    try {
      logger.logInfo(functionName, 'Checking if post is in likes for user', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth
      });

      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromPost)
          .collection(Paths.posts)
          .doc(postId);

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromAuth)
          .collection('likes')
          .where('post_ref', isEqualTo: postRef)
          .get();

      bool result = querySnapshot.docs.isNotEmpty;
      logger.logInfo(functionName, 'Post is in likes check completed', {
        'postId': postId,
        'result': result,
      });

      return result;
    } catch (e) {
      logger.logError(functionName, 'Error checking post in likes for user', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
        'error': e.toString(),
      });
      return false;
    }
  }

  Future<void> deletePostRefFromLikes({
    required String postId,
    required String userIdfromPost,
    required String userIdfromAuth,
  }) async {
    const String functionName = 'deletePostRefFromLikes';
    try {
      logger.logInfo(functionName, 'Deleting post reference from likes', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });

      // Construire la référence correcte du post
      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromPost)
          .collection(Paths.posts)
          .doc(postId);

      // Récupérer les documents likes qui contiennent cette référence de post
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromAuth)
          .collection('likes')
          .where('post_ref', isEqualTo: postRef)
          .get();

      // Si des documents sont trouvés, les supprimer
      if (snapshot.docs.isNotEmpty) {
        await Future.wait(snapshot.docs.map((doc) async {
          // Supprimer la référence dans whoLiked avant de supprimer le document
          await postRef.update({
            'whoLiked.${doc.id}': FieldValue.delete(),
          });
          await doc.reference.delete();
        }));

        logger.logInfo(functionName, 'Post supprimé des likes avec succès.', {
          'postId': postId,
          'userIdfromPost': userIdfromPost,
          'userIdfromAuth': userIdfromAuth,
        });
      } else {
        logger.logInfo(functionName, 'Aucun post trouvé dans les likes.', {
          'postId': postId,
          'userIdfromPost': userIdfromPost,
          'userIdfromAuth': userIdfromAuth,
        });
      }
    } catch (e) {
      logger
          .logError(functionName, 'Error deleting post reference from likes', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
        'error': e.toString(),
      });
      throw e;
    }
  }
}
