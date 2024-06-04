import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'add_post_to_likes_state.dart';

class AddPostToLikesCubit extends Cubit<AddPostToLikesState> {
  final FirebaseFirestore _firebaseFirestore;
  final PostRepository _postRepository;
  final ContextualLogger logger;

  AddPostToLikesCubit({
    required FirebaseFirestore firebaseFirestore,
    required PostRepository postRepository,
  })  : _firebaseFirestore = firebaseFirestore,
        _postRepository = postRepository,
        logger = ContextualLogger('AddPostToLikesCubit'),
        super(AddPostToLikesInitialState());

  Future<void> addPostToLikes(
      String postId, String userIdfromPost, String userIdfromAuth) async {
    emit(AddPostToLikesLoadingState());

    try {
      logger.logInfo(
          'addPostToLikes', 'Adding post to likes...', {
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

      await _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromAuth)
          .collection('likes')
          .add({
        'post_ref': postRef,
        'date': now,
      });

      logger.logInfo('addPostToLikes',
          'Post added to likes successfully', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });

      emit(AddPostToLikesSuccessState());
    } catch (e) {
      logger.logError('addPostToLikes',
          'Error adding post to likes', {
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
      logger.logError('isPostLiked',
          'Error checking if post is liked', {
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
      logger.logInfo('deletePostRefFromLikes',
          'Deleting post from likes...', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });

      await _postRepository.deletePostRefFromLikes(
          postId: postId,
          userIdfromPost: userIdfromPost,
          userIdfromAuth: userIdfromAuth);

      logger.logInfo('deletePostRefFromLikes',
          'Post deleted from likes successfully', {
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });

      emit(AddPostToLikesSuccessState());
    } catch (e) {
      logger.logError('deletePostRefFromLikes',
          'Error deleting post from likes', {
        'error': e.toString(),
        'postId': postId,
        'userIdfromPost': userIdfromPost,
        'userIdfromAuth': userIdfromAuth,
      });
      emit(AddPostToLikesErrorState(e.toString()));
    }
  }
}
