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

  const FeedOOTDCityManFetchPostsByCity({
    required this.locationCountry,
    required this.locationState,
    required this.locationCity,
  });

  @override
  List<Object?> get props => [locationCountry, locationState, locationCity];
}

class FeedOOTDCityManFetchPostsByState extends FeedOOTDCityEvent {
  final String locationCountry;
  final String locationState;

  const FeedOOTDCityManFetchPostsByState({
    required this.locationCountry,
    required this.locationState,
  });

  @override
  List<Object?> get props => [locationCountry, locationState];
}

class FeedOOTDCityManFetchPostsByCountry extends FeedOOTDCityEvent {
  final String locationCountry;

  const FeedOOTDCityManFetchPostsByCountry({
    required this.locationCountry,
  });

  @override
  List<Object?> get props => [locationCountry];
}

class FeedOOTDCityFemaleFetchPostsOOTD extends FeedOOTDCityEvent {
  const FeedOOTDCityFemaleFetchPostsOOTD();

  @override
  List<Object?> get props => [];
}

class FeedOOTDCityManFetchMorePosts extends FeedOOTDCityEvent {
  final String locationCountry;
  final String locationState;
  final String locationCity;

  const FeedOOTDCityManFetchMorePosts({
    required this.locationCountry,
    required this.locationState,
    required this.locationCity,
  });

  @override
  List<Object?> get props => [locationCountry, locationState, locationCity];
}
