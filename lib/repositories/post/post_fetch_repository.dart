import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';

class PostFetchRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  PostFetchRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('PostFetchRepository');

  Stream<List<Future<Post?>>> getUserPosts({required String userId}) {
    const String functionName = 'getUserPosts';
    try {
      logger
          .logInfo(functionName, 'Fetching posts for user', {'userId': userId});
      return _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .orderBy('date', descending: true)
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => Post.fromDocument(doc)).toList());
    } catch (e) {
      logger.logError(functionName, 'Error fetching posts for user', {
        'userId': userId,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  Future<Post?> getPostById(String postId, String userId) async {
    const String functionName = 'getPostById';
    try {
      logger.logInfo(functionName, 'Fetching post by ID',
          {'postId': postId, 'userId': userId});
      DocumentSnapshot postSnap = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .doc(postId)
          .get();

      if (postSnap.exists) {
        logger.logInfo(
            functionName, 'Post fetched successfully', {'postId': postId});
        return Post.fromDocument(postSnap);
      } else {
        logger.logInfo(functionName, 'Post does not exist', {'postId': postId});
        return null;
      }
    } catch (e) {
      logger.logError(functionName, 'Error fetching post', {
        'postId': postId,
        'userId': userId,
        'error': e.toString(),
      });
      return null;
    }
  }
}
