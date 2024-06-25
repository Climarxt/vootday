part of 'feed_ootd_city_bloc.dart';

enum FeedOOTDCityStatus { initial, loading, loaded, paginating, error }

class FeedOOTDCityState extends Equatable implements FeedStateInterface {
  final List<Post?> posts;
  final FeedOOTDCityStatus status;
  final Failure failure;

  const FeedOOTDCityState({
    required this.posts,
    required this.status,
    required this.failure,
  });

  factory FeedOOTDCityState.initial() {
    return const FeedOOTDCityState(
      posts: [],
      status: FeedOOTDCityStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  FeedOOTDCityState copyWith({
    List<Post?>? posts,
    FeedOOTDCityStatus? status,
    Failure? failure,
  }) {
    return FeedOOTDCityState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
