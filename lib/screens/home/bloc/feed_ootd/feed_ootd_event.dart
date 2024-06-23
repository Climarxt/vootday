part of 'feed_ootd_bloc.dart';

abstract class FeedOOTDEvent extends Equatable {
  const FeedOOTDEvent();

  @override
  List<Object?> get props => [];
}

class FeedOOTDManFetchPostsByCity extends FeedOOTDEvent {
  final String locationCountry;
  final String locationState;
  final String locationCity;

  FeedOOTDManFetchPostsByCity({
    this.locationCountry = '',
    this.locationState = '',
    this.locationCity = '',
  });

  @override
  List<Object?> get props => [locationCountry, locationState, locationCity];
}

class FeedOOTDManFetchPostsByState extends FeedOOTDEvent {
  final String locationCountry;
  final String locationState;

  FeedOOTDManFetchPostsByState({
    this.locationCountry = '',
    this.locationState = '',
  });

  @override
  List<Object?> get props => [locationCountry, locationState];
}

class FeedOOTDManFetchPostsByCountry extends FeedOOTDEvent {
  final String locationCountry;

  FeedOOTDManFetchPostsByCountry({
    this.locationCountry = '',
  });

  @override
  List<Object?> get props => [locationCountry];
}

class FeedOOTDFemaleFetchPostsOOTD extends FeedOOTDEvent {}
