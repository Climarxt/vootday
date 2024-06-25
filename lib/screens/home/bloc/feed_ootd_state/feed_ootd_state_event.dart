part of 'feed_ootd_state_bloc.dart';

abstract class FeedOOTDStateEvent extends Equatable {
  const FeedOOTDStateEvent();

  @override
  List<Object?> get props => [];
}

class FeedOOTDStateManFetchPostsByState extends FeedOOTDStateEvent {
  final String locationCountry;
  final String locationState;

  const FeedOOTDStateManFetchPostsByState({
    required this.locationCountry,
    required this.locationState,
  });

  @override
  List<Object?> get props => [locationCountry, locationState];
}

class FeedOOTDStateManFetchMorePosts extends FeedOOTDStateEvent {
  final String locationCountry;
  final String locationState;

  const FeedOOTDStateManFetchMorePosts({
    required this.locationCountry,
    required this.locationState,
  });

  @override
  List<Object?> get props => [locationCountry, locationState];
}

class FeedOOTDStateFemaleFetchPostsOOTD extends FeedOOTDStateEvent {}
