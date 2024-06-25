part of 'feed_ootd_country_bloc.dart';

abstract class FeedOOTDCountryEvent extends Equatable {
  const FeedOOTDCountryEvent();

  @override
  List<Object?> get props => [];
}

class FeedOOTDCountryManFetchPostsByCountry extends FeedOOTDCountryEvent {
  final String locationCountry;

  const FeedOOTDCountryManFetchPostsByCountry({
    required this.locationCountry,
  });

  @override
  List<Object?> get props => [locationCountry];
}

class FeedOOTDCountryManFetchMorePosts extends FeedOOTDCountryEvent {
  final String locationCountry;

  const FeedOOTDCountryManFetchMorePosts({
    required this.locationCountry,
  });

  @override
  List<Object?> get props => [locationCountry];
}

class FeedOOTDCountryFemaleFetchPostsOOTD extends FeedOOTDCountryEvent {}
