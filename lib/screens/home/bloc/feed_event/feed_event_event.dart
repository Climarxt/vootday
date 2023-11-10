part of 'feed_event_bloc.dart';

abstract class FeedEventEvent extends Equatable {
  const FeedEventEvent();

  @override
  List<Object?> get props => [];
}

class FeedEventFetchPostsEvent extends FeedEventEvent {
  final String eventId;

  const FeedEventFetchPostsEvent({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class FeedEventPaginatePosts extends FeedEventEvent {
  final String eventId;

  const FeedEventPaginatePosts({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
