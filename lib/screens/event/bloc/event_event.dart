part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class EventFetchEvent extends EventEvent {
  final String eventId;

  const EventFetchEvent({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
