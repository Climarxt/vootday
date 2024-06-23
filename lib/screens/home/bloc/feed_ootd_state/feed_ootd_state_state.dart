part of 'feed_ootd_state_bloc.dart';

enum FeedOOTDStateStatus { initial, loading, loaded, paginating, error }

class FeedOOTDStateState extends Equatable {
  final List<Post?> posts;
  final FeedOOTDStateStatus status;
  final Failure failure;

  const FeedOOTDStateState({
    required this.posts,
    required this.status,
    required this.failure,
  });

  factory FeedOOTDStateState.initial() {
    return const FeedOOTDStateState(
      posts: [],
      status: FeedOOTDStateStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  FeedOOTDStateState copyWith({
    List<Post?>? posts,
    FeedOOTDStateStatus? status,
    Failure? failure,
  }) {
    return FeedOOTDStateState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
