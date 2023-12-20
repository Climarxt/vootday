part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

class CommentsFetchComments extends CommentsEvent {
  final String postId;

  const CommentsFetchComments({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class CommentsUpdateComments extends CommentsEvent {
  final List<Comment?> comments;

  const CommentsUpdateComments({required this.comments});

  @override
  List<Object?> get props => [comments];
}

class CommentsPostComment extends CommentsEvent {
  final String content;
  final String postId; // Ajoutez cette ligne

  const CommentsPostComment({
    required this.content,
    required this.postId, // Ajoutez cette ligne
  });

  @override
  List<Object?> get props => [content, postId]; // Modifiez cette ligne
}
