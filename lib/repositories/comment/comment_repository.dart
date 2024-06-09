import 'package:bootdv2/config/enums/enums.dart';
import 'package:bootdv2/config/paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/config/logger/logger.dart';

class CommentRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  CommentRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('CommentRepository');

  Future<void> createComment({
    required Post post,
    required Comment comment,
  }) async {
    const String functionName = 'createComment';
    try {
      logger.logInfo(functionName, 'Starting method createComment', {
        'postId': post.id,
        'commentId': comment.id,
      });

      logger.logInfo(functionName, 'Adding comment to Firestore', {
        'postId': comment.postId,
        'authorId': comment.author.id,
      });

      await _firebaseFirestore
          .collection(Paths.comments)
          .doc(comment.postId)
          .collection(Paths.postComments)
          .add(comment.toDocument());

      logger.logInfo(functionName, 'Comment added successfully', {
        'postId': comment.postId,
        'commentId': comment.id,
      });

      logger.logInfo(functionName, 'Creating notification', {
        'postId': post.id,
        'authorId': post.author.id,
      });

      final notification = Notif(
        type: NotifType.comment,
        fromUser: comment.author,
        post: post,
        date: DateTime.now(),
      );

      logger.logInfo(functionName, 'Adding notification to Firestore', {
        'postId': post.id,
        'notificationType': NotifType.comment.toString(),
      });

      await _firebaseFirestore
          .collection(Paths.notifications)
          .doc(post.author.id)
          .collection(Paths.userNotifications)
          .add(notification.toDocument());

      logger.logInfo(functionName, 'Notification added successfully', {
        'postId': post.id,
        'notificationId': notification.id,
      });

      logger.logInfo(functionName, 'End of method createComment');
    } catch (e) {
      logger.logError(functionName, 'Error creating comment or notification', {
        'postId': post.id,
        'commentId': comment.id,
        'error': e.toString(),
      });
      throw e;
    }
  }

  Stream<List<Future<Comment?>>> getPostComments({required String postId}) {
    const String functionName = 'getPostComments';
    try {
      logger.logInfo(functionName, 'Fetching comments for post', {
        'postId': postId,
      });

      return _firebaseFirestore
          .collection(Paths.comments)
          .doc(postId)
          .collection(Paths.postComments)
          .orderBy('date', descending: false)
          .snapshots()
          .map((snap) {
        logger.logInfo(functionName, 'Comments fetched successfully', {
          'postId': postId,
          'commentsCount': snap.docs.length,
        });
        return snap.docs.map((doc) => Comment.fromDocument(doc)).toList();
      });
    } catch (e) {
      logger.logError(functionName, 'Error fetching comments', {
        'postId': postId,
        'error': e.toString(),
      });
      rethrow;
    }
  }
}
