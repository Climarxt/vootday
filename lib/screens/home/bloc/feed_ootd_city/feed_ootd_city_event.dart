part of 'feed_ootd_city_bloc.dart';

abstract class FeedOOTDCityEvent extends Equatable {
  const FeedOOTDCityEvent();

  @override
  List<Object?> get props => [];
}

class FeedOOTDCityManFetchPostsByCity extends FeedOOTDCityEvent {
  final String locationCountry;
  final String locationState;
  final String locationCity;

  FeedOOTDCityManFetchPostsByCity({
    this.locationCountry = '',
    this.locationState = '',
    this.locationCity = '',
  });

  @override
  List<Object?> get props => [locationCountry, locationState, locationCity];
}

class FeedOOTDCityManFetchPostsByState extends FeedOOTDCityEvent {
  final String locationCountry;
  final String locationState;

  FeedOOTDCityManFetchPostsByState({
    this.locationCountry = '',
    this.locationState = '',
  });

  @override
  List<Object?> get props => [locationCountry, locationState];
}

class FeedOOTDCityManFetchPostsByCountry extends FeedOOTDCityEvent {
  final String locationCountry;

  FeedOOTDCityManFetchPostsByCountry({
    this.locationCountry = '',
  });

  @override
  List<Object?> get props => [locationCountry];
}

class FeedOOTDCityFemaleFetchPostsOOTD extends FeedOOTDCityEvent {}
