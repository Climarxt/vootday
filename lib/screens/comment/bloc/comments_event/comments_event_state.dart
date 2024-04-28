part of 'comments_event_bloc.dart';

enum CommentsEventStatus { initial, loading, loaded, submitting, error }

class CommentsEventState extends Equatable {
  final Event? event;
  final List<Comment?> comments;
  final CommentsEventStatus status;
  final Failure failure;

  const CommentsEventState({
    required this.event,
    required this.comments,
    required this.status,
    required this.failure,
  });

  factory CommentsEventState.initial() {
    return const CommentsEventState(
      event: null,
      comments: [],
      status: CommentsEventStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [event, comments, status, failure];

  CommentsEventState copyWith({
    Event? event,
    List<Comment?>? comments,
    CommentsEventStatus? status,
    Failure? failure,
  }) {
    return CommentsEventState(
      event: event ?? this.event,
      comments: comments ?? this.comments,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
