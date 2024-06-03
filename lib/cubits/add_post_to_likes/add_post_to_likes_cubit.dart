import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

part 'add_post_to_likes_state.dart';

class AddPostToLikesCubit extends Cubit<AddPostToLikesState> {
  final FirebaseFirestore _firebaseFirestore;
  final PostRepository _postRepository;

  AddPostToLikesCubit({
    required FirebaseFirestore firebaseFirestore,
    required PostRepository postRepository,
  })  : _firebaseFirestore = firebaseFirestore,
        _postRepository = postRepository,
        super(AddPostToLikesInitialState());

  Future<void> addPostToLikes(String postId, String userId) async {
    emit(AddPostToLikesLoadingState());

    try {
      debugPrint('AddPostToLikesCubit : Adding post to likes...');

      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.posts)
          .doc(postId);
      DateTime now = DateTime.now();

      await _firebaseFirestore
          .collection(Paths.users)
          .doc(userId)
          .collection('likes')
          .add({
        'post_ref': postRef,
        'date': now,
      });

      debugPrint(
          'AddPostToLikesCubit : Post added to collection successfully.');

      emit(AddPostToLikesSuccessState());
    } catch (e) {
      debugPrint(
          'AddPostToLikesCubit : Error adding post to collection: ${e.toString()}');
      emit(AddPostToLikesErrorState(e.toString()));
    }
  }

  Future<bool> isPostLiked(String postId, String userId) async {
    final likedPostsSnapshot = await _firebaseFirestore
        .collection(Paths.users)
        .doc(userId)
        .collection('likes')
        .where('post_ref',
            isEqualTo: _firebaseFirestore
                .collection(Paths.users)
                .doc(userId)
                .collection(Paths.posts)
                .doc(postId))
        .get();

    return likedPostsSnapshot.docs.isNotEmpty;
  }

  Future<void> deletePostRefFromLikes(
      {required String postId, required String userId}) async {
    emit(AddPostToLikesLoadingState());

    try {
      debugPrint('deletePostRefFromLikes : Deleting post from likes...');

      await _postRepository.deletePostRefFromLikes(
          postId: postId, userId: userId);

      debugPrint('deletePostRefFromLikes : Post deleted from likes successfully.');

      emit(AddPostToLikesSuccessState());
    } catch (e) {
      debugPrint(
          'deletePostRefFromLikes : Error deleting post from likes: ${e.toString()}');
      emit(AddPostToLikesErrorState(e.toString()));
    }
  }
}
