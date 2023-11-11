part of 'feed_event_bloc.dart';

abstract class FeedEventEvent extends Equatable {
  const FeedEventEvent();

  @override
  List<Object?> get props => [];
}

class FeedEventFetchPostsEvents extends FeedEventEvent {
  final String eventId;

  const FeedEventFetchPostsEvents({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class FeedEventPaginatePostsEvents extends FeedEventEvent {
  final String eventId;

  const FeedEventPaginatePostsEvents({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class FeedEventClean extends FeedEventEvent {}

class FeedEventFetchEventDetails extends FeedEventEvent {
  final String eventId;

  const FeedEventFetchEventDetails({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
