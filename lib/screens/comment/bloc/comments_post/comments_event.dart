part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

class CommentsFetchComments extends CommentsEvent {
  final String postId;
  final String userId;

  const CommentsFetchComments({required this.postId, required this.userId});

  @override
  List<Object?> get props => [postId, userId];
}

class CommentsUpdateComments extends CommentsEvent {
  final List<Comment?> comments;
  final String userId;

  const CommentsUpdateComments({required this.comments, required this.userId});

  @override
  List<Object?> get props => [comments, userId];
}

class CommentsPostComment extends CommentsEvent {
  final String content;
  final String postId;
  final String userId;

  const CommentsPostComment(
      {required this.content, required this.postId, required this.userId});

  @override
  List<Object?> get props => [content, postId, userId];
}
