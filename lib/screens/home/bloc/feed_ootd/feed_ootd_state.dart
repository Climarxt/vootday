part of 'feed_ootd_bloc.dart';

enum FeedOOTDStatus { initial, loading, loaded, paginating, error }

class FeedOOTDState extends Equatable {
  final List<Post?> posts;
  final FeedOOTDStatus status;
  final Failure failure;

  const FeedOOTDState({
    required this.posts,
    required this.status,
    required this.failure,
  });

  factory FeedOOTDState.initial() {
    return const FeedOOTDState(
      posts: [],
      status: FeedOOTDStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  FeedOOTDState copyWith({
    List<Post?>? posts,
    FeedOOTDStatus? status,
    Failure? failure,
  }) {
    return FeedOOTDState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
