part of 'comments_event_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

class CommentsEventFetchComments extends CommentsEvent {
  final String eventId;

  const CommentsEventFetchComments({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class CommentsUpdateComments extends CommentsEvent {
  final List<Comment?> comments;

  const CommentsUpdateComments({required this.comments});

  @override
  List<Object?> get props => [comments];
}

class CommentsPostComment extends CommentsEvent {
  final String content;
  final String eventId; // Ajoutez cette ligne

  const CommentsPostComment({
    required this.content,
    required this.eventId, // Ajoutez cette ligne
  });

  @override
  List<Object?> get props => [content, eventId]; // Modifiez cette ligne
}
