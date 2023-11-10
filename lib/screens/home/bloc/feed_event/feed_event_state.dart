part of 'feed_event_bloc.dart';

enum FeedEventStatus { initial, loading, loaded, paginating, error }

class FeedEventState extends Equatable {
  final List<Post?> posts;
  final Event? event;
  final FeedEventStatus status;
  final Failure failure;

  const FeedEventState({
    required this.posts,
    required this.event,
    required this.status,
    required this.failure,
  });

  factory FeedEventState.initial() {
    return const FeedEventState(
      posts: [],
      status: FeedEventStatus.initial,
      failure: Failure(),
      event: null,
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  FeedEventState copyWith({
    List<Post?>? posts,
    FeedEventStatus? status,
    Failure? failure,
    Event? event,
  }) {
    return FeedEventState(
      posts: posts ?? this.posts,
      event: event ?? event,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
