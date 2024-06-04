import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'add_post_to_collection_state.dart';

class AddPostToCollectionCubit extends Cubit<AddPostToCollectionState> {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  AddPostToCollectionCubit({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore,
        logger = ContextualLogger('AddPostToCollectionCubit'),
        super(AddPostToCollectionInitialState());

  Future<void> addPostToCollection(
      String postId, String collectionId, String userIdfromPost) async {
    const String functionName = 'addPostToCollection';
    emit(AddPostToCollectionLoadingState());

    try {
      logger.logInfo(functionName, 'Adding post to collection', {
        'postId': postId,
        'collectionId': collectionId,
        'userIdfromPost': userIdfromPost,
      });

      // Construire la référence correcte du post
      DocumentReference postRef = _firebaseFirestore
          .collection(Paths.users)
          .doc(userIdfromPost)
          .collection(Paths.posts)
          .doc(postId);
      DateTime now = DateTime.now();

      await _firebaseFirestore
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection')
          .add({
        'post_ref': postRef,
        'date': now,
      });

      logger.logInfo(functionName, 'Post added to collection successfully', {
        'postId': postId,
        'collectionId': collectionId,
        'userIdfromPost': userIdfromPost,
      });

      emit(AddPostToCollectionSuccessState());
    } catch (e) {
      logger.logError(functionName, 'Error adding post to collection', {
        'postId': postId,
        'collectionId': collectionId,
        'userIdfromPost': userIdfromPost,
        'error': e.toString(),
      });
      emit(AddPostToCollectionErrorState(e.toString()));
    }
  }
}
