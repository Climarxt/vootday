part of 'feed_ootd_country_bloc.dart';

enum FeedOOTDCountryStatus { initial, loading, loaded, paginating, error }

class FeedOOTDCountryState extends Equatable implements FeedStateInterface {
  final List<Post?> posts;
  final FeedOOTDCountryStatus status;
  final Failure failure;

  const FeedOOTDCountryState({
    required this.posts,
    required this.status,
    required this.failure,
  });

  factory FeedOOTDCountryState.initial() {
    return const FeedOOTDCountryState(
      posts: [],
      status: FeedOOTDCountryStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  FeedOOTDCountryState copyWith({
    List<Post?>? posts,
    FeedOOTDCountryStatus? status,
    Failure? failure,
  }) {
    return FeedOOTDCountryState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
