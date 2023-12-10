part of 'feed_ootd_bloc.dart';

abstract class FeedOOTDEvent extends Equatable {
  const FeedOOTDEvent();

  @override
  List<Object?> get props => [];
}

class FeedOOTDFetchPostsOOTD extends FeedOOTDEvent {}