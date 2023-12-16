part of 'add_post_to_likes_cubit.dart';

abstract class AddPostToLikesState {}

class AddPostToLikesInitialState extends AddPostToLikesState {}

class AddPostToLikesLoadingState extends AddPostToLikesState {}

class AddPostToLikesSuccessState extends AddPostToLikesState {}

class AddPostToLikesErrorState extends AddPostToLikesState {
  final String error;

  AddPostToLikesErrorState(this.error);
}
