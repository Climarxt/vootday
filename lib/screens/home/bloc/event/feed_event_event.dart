part of 'feed_event_bloc.dart';

abstract class FeedEventEvent extends Equatable {
  const FeedEventEvent();

  @override
  List<Object?> get props => [];
}

class FeedEventFetchPosts extends FeedEventEvent {}

class FeedEventFetchPostsMonth extends FeedEventEvent {}

class FeedEventPaginatePosts extends FeedEventEvent {}

class FeedEventFetchEvents extends FeedEventEvent {}