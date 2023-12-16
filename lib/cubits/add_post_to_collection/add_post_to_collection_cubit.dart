import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

part 'add_post_to_collection_state.dart';

class AddPostToCollectionCubit extends Cubit<AddPostToCollectionState> {
  final FirebaseFirestore _firebaseFirestore;

  AddPostToCollectionCubit({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore,
        super(AddPostToCollectionInitialState());

  Future<void> addPostToCollection(String postId, String collectionId) async {
    emit(AddPostToCollectionLoadingState());

    try {
      debugPrint('AddPostToCollectionCubit : Adding post to collection...');

      DocumentReference postRef =
          _firebaseFirestore.collection('posts').doc(postId);
      DateTime now = DateTime.now();

      await _firebaseFirestore
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection')
          .add({
        'post_ref': postRef,
        'date': now,
      });

      debugPrint(
          'AddPostToCollectionCubit : Post added to collection successfully.');

      emit(AddPostToCollectionSuccessState());
    } catch (e) {
      debugPrint(
          'AddPostToCollectionCubit : Error adding post to collection: ${e.toString()}');
      emit(AddPostToCollectionErrorState(e.toString()));
    }
  }
}
