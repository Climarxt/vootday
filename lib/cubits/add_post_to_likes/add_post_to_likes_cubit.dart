import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'add_post_to_likes_state.dart';

class AddPostToLikesCubit extends Cubit<AddPostToLikesState> {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  AddPostToLikesCubit({
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseFirestore = firebaseFirestore,
        logger = ContextualLogger('AddPostToLikesCubit'),
        super(AddPostToLikesInitialState());

  Future<void> addPostToLikes(
      String postId, String userIdfromPost, String userIdfromAuth) async {
    emit(AddPostToLikesLoadingState());

    try {
      logger.logInfo('addPostToLikes', 'Adding post to likes...', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });

      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromPost)
          .collection(Paths.posts)
          .doc(postId);
      DateTime now = DateTime.now();

      // Get a new document reference for the like
      DocumentReference likeRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromAuth)
          .collection('likes')
          .doc();

      // Add post reference to user's likes collection with the generated ID
      await likeRef.set({
        'post_ref': postRef,
        'date': now,
      });

      // Update whoLiked map in the post document
      await postRef.update({
        'whoLiked.${likeRef.id}': likeRef,
      });

      logger.logInfo('addPostToLikes', 'Post added to likes successfully', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });

      emit(AddPostToLikesSuccessState());
    } catch (e) {
      logger.logError('addPostToLikes', 'Error adding post to likes', {
        'error': e.toString(),
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });
      emit(AddPostToLikesErrorState(e.toString()));
    }
  }

  Future<bool> isPostLiked(
      String postId, String userIdfromPost, String userIdfromAuth) async {
    try {
      final likedPostsSnapshot = await _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromAuth)
          .collection('likes')
          .where('post_ref',
              isEqualTo: _firebaseFirestore
                  .collection(Paths.users)
                  .doc(userIdfromPost)
                  .collection(Paths.posts)
                  .doc(postId))
          .get();

      return likedPostsSnapshot.docs.isNotEmpty;
    } catch (e) {
      logger.logError('isPostLiked', 'Error checking if post is liked', {
        'error': e.toString(),
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });
      return false;
    }
  }

  Future<void> deletePostRefFromLikes(
      {required String postId,
      required String userIdfromPost,
      required String userIdfromAuth}) async {
    emit(AddPostToLikesLoadingState());

    try {
      logger.logInfo('deletePostRefFromLikes', 'Deleting post from likes...', {
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

        logger.logInfo(
            'deletePostRefFromLikes', 'Post deleted from likes successfully.', {
          'postId': postId,
          'userIdfromPost': userIdfromPost,
          'userIdfromAuth': userIdfromAuth,
        });
      } else {
        logger.logInfo('deletePostRefFromLikes', 'No post found in likes.', {
          'postId': postId,
          'userIdfromPost': userIdfromPost,
          'userIdfromAuth': userIdfromAuth,
        });
      }

      emit(AddPostToLikesSuccessState());
    } catch (e) {
      logger.logError(
          'deletePostRefFromLikes', 'Error deleting post from likes', {
        'error': e.toString(),
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });
      emit(AddPostToLikesErrorState(e.toString()));
    }
  }
}
