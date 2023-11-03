part of 'feed_ootd_bloc.dart';

abstract class FeedOOTDEvent extends Equatable {
  const FeedOOTDEvent();

  @override
  List<Object?> get props => [];
}

class FeedOOTDFetchPosts extends FeedOOTDEvent {}

class FeedOOTDFetchPostsOOTD extends FeedOOTDEvent {}


class FeedOOTDFetchPostsMonth extends FeedOOTDEvent {}

class FeedOOTDPaginatePosts extends FeedOOTDEvent {}
