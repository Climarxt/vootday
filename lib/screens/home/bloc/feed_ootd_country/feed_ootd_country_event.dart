part of 'feed_ootd_country_bloc.dart';

abstract class FeedOOTDCountryEvent extends Equatable {
  const FeedOOTDCountryEvent();

  @override
  List<Object?> get props => [];
}

class FeedOOTDCountryManFetchPostsByCountry extends FeedOOTDCountryEvent {
  final String locationCountry;

  FeedOOTDCountryManFetchPostsByCountry({
    this.locationCountry = '',
  });

  @override
  List<Object?> get props => [locationCountry];
}

class FeedOOTDCountryFemaleFetchPostsOOTD extends FeedOOTDCountryEvent {}
