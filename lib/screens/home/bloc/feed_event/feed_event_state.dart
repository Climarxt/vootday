part of 'feed_event_bloc.dart';

enum FeedEventStatus { initial, loading, loaded, paginating, error }

class FeedEventState extends Equatable {
  final List<Post?> posts;
  final FeedEventStatus status;
  final Failure failure;

  const FeedEventState({
    required this.posts,
    required this.status,
    required this.failure,
  });

  factory FeedEventState.initial() {
    return const FeedEventState(
      posts: [],
      status: FeedEventStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  FeedEventState copyWith({
    List<Post?>? posts,
    FeedEventStatus? status,
    Failure? failure,
  }) {
    return FeedEventState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}