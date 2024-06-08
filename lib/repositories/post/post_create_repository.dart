import 'package:bootdv2/config/configs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';

class PostCreateRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  PostCreateRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('PostCreateRepository');

  Future<void> createPost({
    required Post post,
    required String userId,
    required DateTime dateTime,
  }) async {
    const String functionName = 'createPost';
    try {
      logger.logInfo(functionName, 'Creating post for user', {
        'userId': userId,
        'postId': post.id,
        'dateTime': dateTime.toIso8601String(),
      });

      final userPostRef = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .add({
        ...post.toDocument(),
        'date': dateTime,
      });

      logger.logInfo(functionName, 'Post created in user collection', {
        'userPostRef': userPostRef.id,
        'userId': userId,
      });

      String genderPath =
          post.selectedGender == 'Masculin' ? 'posts_man' : 'posts_woman';
      String locationPath = _getLocationPath(post);

      final locationPostRef = await _firebaseFirestore
          .collection('$genderPath/$locationPath/posts')
          .add({
        'post_ref': userPostRef,
        'date': dateTime,
      });

      logger.logInfo(functionName, 'Location post reference created', {
        'locationPostRef': locationPostRef.id,
        'genderPath': genderPath,
        'locationPath': locationPath,
      });

      await userPostRef.update({'postReference': locationPostRef});

      logger.logInfo(functionName, 'Post reference updated in user post', {
        'userPostRef': userPostRef.id,
        'locationPostRef': locationPostRef.id,
      });
    } catch (e) {
      logger.logError(functionName, 'Error creating post for user', {
        'userId': userId,
        'postId': post.id,
        'dateTime': dateTime.toIso8601String(),
        'error': e.toString(),
      });
    }
  }

  Future<void> createPostEvent(
      {required Post post, required String eventId}) async {
    const String functionName = 'createPostEvent';

    try {
      logger.logInfo(functionName, 'Creating post event',
          {'postId': post.id, 'eventId': eventId, 'authorId': post.author.id});

      DocumentReference postRef =
          _firebaseFirestore.collection(Paths.posts).doc();

      final postDocument = post.copyWith(id: postRef.id).toDocument();

      final participantDocument = {
        'post_ref': postRef,
        'userId': post.author.id
      };

      await _firebaseFirestore.runTransaction((transaction) async {
        transaction.set(postRef, postDocument);

        DocumentReference participantRef = _firebaseFirestore
            .collection(Paths.events)
            .doc(eventId)
            .collection('participants')
            .doc();
        transaction.set(participantRef, participantDocument);
      });

      logger.logInfo(functionName, 'Post event created successfully',
          {'postId': post.id, 'eventId': eventId});
    } catch (e) {
      logger.logError(functionName, 'Error creating post event', {
        'postId': post.id,
        'eventId': eventId,
        'authorId': post.author.id,
        'error': e.toString()
      });
      rethrow;
    }
  }

  String _getLocationPath(Post post) {
    const String functionName = '_getLocationPath';

    try {
      String locationPath;

      if (post.locationSelected == post.locationCountry) {
        locationPath = post.locationCountry;
      } else if (post.locationSelected == post.locationState) {
        locationPath = '${post.locationCountry}/regions/${post.locationState}';
      } else if (post.locationSelected == post.locationCity) {
        locationPath =
            '${post.locationCountry}/regions/${post.locationState}/cities/${post.locationCity}';
      } else {
        throw Exception('Invalid location selected');
      }

      logger.logInfo(functionName, 'Location path determined',
          {'postId': post.id, 'locationPath': locationPath});

      return locationPath;
    } catch (e) {
      logger.logError(functionName, 'Error determining location path',
          {'postId': post.id, 'error': e.toString()});
      rethrow;
    }
  }
}
