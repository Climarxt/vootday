import 'package:bootdv2/config/paths.dart';
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
    const String functionName = 'deletePost';
    WriteBatch batch = _firebaseFirestore.batch();
    logger.logInfo(functionName, 'Starting post deletion',
        {'postId': postId, 'userIdfromAuth': userIdfromAuth});

    DocumentReference postRef = _firebaseFirestore
        .collection('users')
        .doc(userIdfromAuth)
        .collection('posts')
        .doc(postId);
    batch.delete(postRef);

    try {
      await _deletePostReferencesInSubCollections(
          batch, postRef, 'participants');
      await _deletePostReferencesInSubCollections(
          batch, postRef, 'postReference');
      await _deleteReferencedPost(postRef);
      await _deleteWhoLikedReferences(postRef);

      await batch.commit();

      WriteBatch userFeedBatch = _firebaseFirestore.batch();
      await _deletePostReferencesInUserFeeds(userFeedBatch, postRef);
      await userFeedBatch.commit();

      logger.logInfo(functionName, 'Post deletion completed',
          {'postId': postId, 'userIdfromAuth': userIdfromAuth});
    } catch (e) {
      logger.logError(functionName, 'Error during post deletion', {
        'postId': postId,
        'userIdfromAuth': userIdfromAuth,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  Future<void> _deleteReferencedPost(DocumentReference postRef) async {
    const String functionName = '_deleteReferencedPost';
    try {
      DocumentSnapshot postSnapshot = await postRef.get();
      if (postSnapshot.exists) {
        var postData = postSnapshot.data() as Map<String, dynamic>?;
        if (postData != null) {
          var postReference = postData['postReference'];
          if (postReference != null && postReference is DocumentReference) {
            logger.logInfo(functionName, 'Deleting referenced post',
                {'postReference': postReference});
            await postReference.delete();
          } else {
            logger.logInfo(
                functionName, 'postReference field is not a DocumentReference');
          }
        } else {
          logger.logInfo(functionName, 'Main post data is null');
        }
      } else {
        logger.logInfo(functionName, 'Main post does not exist');
      }
    } catch (e) {
      logger.logError(functionName, 'Error deleting referenced post',
          {'postRef': postRef, 'error': e.toString()});
    }
  }

  Future<void> _deletePostReferencesInSubCollections(
      WriteBatch batch, DocumentReference postRef, String subCollection) async {
    const String functionName = '_deletePostReferencesInSubCollections';
    logger.logInfo(functionName, 'Searching for post in sub-collections',
        {'subCollection': subCollection, 'postRef': postRef});

    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collectionGroup(subCollection)
          .where('post_ref', isEqualTo: postRef)
          .get();

      if (snapshot.docs.isEmpty) {
        logger.logInfo(functionName, 'No references found in sub-collection',
            {'subCollection': subCollection});
      } else {
        logger.logInfo(functionName, 'References found in sub-collection',
            {'subCollection': subCollection, 'count': snapshot.docs.length});
        for (var doc in snapshot.docs) {
          logger.logInfo(functionName, 'Deleting reference in batch',
              {'docId': doc.id, 'subCollection': subCollection});
          batch.delete(doc.reference);
        }
      }
    } catch (e) {
      logger.logError(
          functionName, 'Error deleting references in sub-collections', {
        'subCollection': subCollection,
        'postRef': postRef,
        'error': e.toString()
      });
    }
  }

  Future<void> _deleteWhoLikedReferences(DocumentReference postRef) async {
    const String functionName = '_deleteWhoLikedReferences';
    try {
      DocumentSnapshot postSnapshot = await postRef.get();
      if (postSnapshot.exists) {
        var postData = postSnapshot.data() as Map<String, dynamic>?;
        if (postData != null && postData.containsKey('whoLiked')) {
          var whoLiked = postData['whoLiked'] as Map<String, dynamic>;
          for (var likeId in whoLiked.keys) {
            DocumentReference likeRef = whoLiked[likeId];
            logger.logInfo(
                functionName, 'Deleting like reference', {'likeId': likeId});
            await likeRef.delete();
          }
        } else {
          logger.logInfo(
              functionName, 'No whoLiked field found or it is empty');
        }
      } else {
        logger.logInfo(functionName, 'Main post does not exist');
      }
    } catch (e) {
      logger.logError(functionName, 'Error deleting whoLiked references',
          {'postRef': postRef, 'error': e.toString()});
    }
  }

  Future<void> _deletePostReferencesInUserFeeds(
      WriteBatch batch, DocumentReference postRef) async {
    const String functionName = '_deletePostReferencesInUserFeeds';
    logger.logInfo(
        functionName, 'Searching for post in userFeed', {'postRef': postRef});

    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collectionGroup(Paths.userFeed)
          .where('post_ref', isEqualTo: postRef)
          .get();

      if (snapshot.docs.isEmpty) {
        logger.logInfo(functionName, 'No references found in userFeed',
            {'postRef': postRef});
      } else {
        logger.logInfo(functionName, 'References found in userFeed',
            {'count': snapshot.docs.length, 'postRef': postRef});
        for (var doc in snapshot.docs) {
          logger.logInfo(functionName, 'Deleting reference in userFeed batch',
              {'docId': doc.id});
          batch.delete(doc.reference);
        }
      }
    } catch (e) {
      logger.logError(functionName, 'Error deleting references in userFeed',
          {'postRef': postRef, 'error': e.toString()});
    }
  }
}
