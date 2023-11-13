part of 'event_bloc.dart';

enum EventStatus { initial, loading, loaded, noEvents, error }

class EventState extends Equatable {
  final Event? event;
  final EventStatus status;
  final Failure failure;

  const EventState({
    this.event,
    required this.status,
    required this.failure,
  });

  factory EventState.initial() {
    return const EventState(
      event: null,
      status: EventStatus.initial,
      failure: Failure(),
    );
  }

  factory EventState.loading() {
    return const EventState(
      event: null,
      status: EventStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [event, status, failure];

  EventState copyWith({
    Event? event,
    EventStatus? status,
    Failure? failure,
  }) {
    return EventState(
      event: event ?? this.event,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
