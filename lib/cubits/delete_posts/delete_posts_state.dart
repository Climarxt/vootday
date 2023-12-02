part of 'delete_posts_cubit.dart';

abstract class DeletePostsState {}

class DeletePostsInitial extends DeletePostsState {}

class DeletePostsLoading extends DeletePostsState {}

class DeletePostsSuccess extends DeletePostsState {}

class DeletePostsError extends DeletePostsState {
  final String message;

  DeletePostsError(this.message);
}
