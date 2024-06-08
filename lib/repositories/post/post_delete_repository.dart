import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bootdv2/config/logger/logger.dart';

class PostDeleteRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  PostDeleteRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('PostDeleteRepository');

  Future<void> deletePost({
    required String postId,
    required String userIdfromAuth,
  }) async {
    WriteBatch batch = _firebaseFirestore.batch();
    logger.logInfo('deletePost', 'Starting post deletion', {'postId': postId});

    DocumentReference postRef = _firebaseFirestore
        .collection('users')
        .doc(userIdfromAuth)
        .collection('posts')
        .doc(postId);
    batch.delete(postRef);

    await _deletePostReferencesInSubCollections(batch, postRef, 'participants');
    await _deletePostReferencesInSubCollections(
        batch, postRef, 'postReference');
    await _deleteReferencedPost(postRef);
    await _deleteWhoLikedReferences(postRef);

    await batch.commit();

    WriteBatch userFeedBatch = _firebaseFirestore.batch();
    await _deletePostReferencesInUserFeeds(userFeedBatch, postRef);
    await userFeedBatch.commit();

    logger.logInfo('deletePost', 'Post deletion completed', {'postId': postId});
  }

  Future<void> _deleteReferencedPost(DocumentReference postRef) async {
    // Your existing _deleteReferencedPost implementation
  }

  Future<void> _deletePostReferencesInSubCollections(
      WriteBatch batch, DocumentReference postRef, String subCollection) async {
    // Your existing _deletePostReferencesInSubCollections implementation
  }

  Future<void> _deleteWhoLikedReferences(DocumentReference postRef) async {
    // Your existing _deleteWhoLikedReferences implementation
  }

  Future<void> _deletePostReferencesInUserFeeds(
      WriteBatch batch, DocumentReference postRef) async {
    // Your existing _deletePostReferencesInUserFeeds implementation
  }
}
