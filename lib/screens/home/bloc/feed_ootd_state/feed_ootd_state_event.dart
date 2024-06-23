part of 'feed_ootd_state_bloc.dart';

abstract class FeedOOTDStateEvent extends Equatable {
  const FeedOOTDStateEvent();

  @override
  List<Object?> get props => [];
}

class FeedOOTDStateManFetchPostsByCity extends FeedOOTDStateEvent {
  final String locationCountry;
  final String locationState;

  FeedOOTDStateManFetchPostsByCity({
    this.locationCountry = '',
    this.locationState = '',
  });

  @override
  List<Object?> get props => [locationCountry, locationState];
}

class FeedOOTDStateManFetchPostsByState extends FeedOOTDStateEvent {
  final String locationCountry;
  final String locationState;

  FeedOOTDStateManFetchPostsByState({
    this.locationCountry = '',
    this.locationState = '',
  });

  @override
  List<Object?> get props => [locationCountry, locationState];
}

class FeedOOTDStateFemaleFetchPostsOOTD extends FeedOOTDStateEvent {}
