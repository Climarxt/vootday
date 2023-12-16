part of 'add_post_to_collection_cubit.dart';

abstract class AddPostToCollectionState {}

class AddPostToCollectionInitialState extends AddPostToCollectionState {}

class AddPostToCollectionLoadingState extends AddPostToCollectionState {}

class AddPostToCollectionSuccessState extends AddPostToCollectionState {}

class AddPostToCollectionErrorState extends AddPostToCollectionState {
  final String error;

  AddPostToCollectionErrorState(this.error);
}
