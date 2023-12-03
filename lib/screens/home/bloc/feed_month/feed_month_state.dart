part of 'feed_month_bloc.dart';

enum FeedMonthStatus { initial, loading, loaded, paginating, error }

class FeedMonthState extends Equatable {
  final List<Post?> posts;
  final FeedMonthStatus status;
  final Failure failure;

  const FeedMonthState({
    required this.posts,
    required this.status,
    required this.failure,
  });

  factory FeedMonthState.initial() {
    return const FeedMonthState(
      posts: [],
      status: FeedMonthStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  FeedMonthState copyWith({
    List<Post?>? posts,
    FeedMonthStatus? status,
    Failure? failure,
  }) {
    return FeedMonthState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
