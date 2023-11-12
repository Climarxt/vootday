part of 'calendar_latest_bloc.dart';

enum CalendarLatestEventStatus { initial, loading, loaded, noEvents, error }

class CalendarLatestEventState extends Equatable {
  final Event? latestEvent;
  final CalendarLatestEventStatus status;
  final Failure failure;

  const CalendarLatestEventState({
    this.latestEvent,
    required this.status,
    required this.failure,
  });

  factory CalendarLatestEventState.initial() {
    return const CalendarLatestEventState(
      latestEvent: null,
      status: CalendarLatestEventStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [latestEvent, status, failure];

  CalendarLatestEventState copyWith({
    Event? latestEvent,
    CalendarLatestEventStatus? status,
    Failure? failure,
  }) {
    return CalendarLatestEventState(
      latestEvent: latestEvent ?? this.latestEvent,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
