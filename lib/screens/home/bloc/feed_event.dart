part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedFetchPosts extends FeedEvent {}

class FeedFetchPostsOOTD extends FeedEvent {}

class FeedFetchPostsMonth extends FeedEvent {}

class FeedPaginatePosts extends FeedEvent {}
