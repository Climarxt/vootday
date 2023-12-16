import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

part 'add_post_to_likes_state.dart';

class AddPostToLikesCubit extends Cubit<AddPostToLikesState> {
  final FirebaseFirestore _firebaseFirestore;

  AddPostToLikesCubit({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore,
        super(AddPostToLikesInitialState());

  Future<void> addPostToLikes(String postId, String userId) async {
    emit(AddPostToLikesLoadingState());

    try {
      debugPrint('AddPostToLikesCubit : Adding post to likes...');

      DocumentReference postRef =
          _firebaseFirestore.collection('posts').doc(postId);
      DateTime now = DateTime.now();

      await _firebaseFirestore
          .collection('users')
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
}
