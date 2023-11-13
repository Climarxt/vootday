part of 'calendar_latest_bloc.dart';

enum CalendarLatestStatus { initial, loading, loaded, noEvents, error }

class CalendarLatestState extends Equatable {
  final Event? latestEvent;
  final CalendarLatestStatus status;
  final Failure failure;

  const CalendarLatestState({
    this.latestEvent,
    required this.status,
    required this.failure,
  });

  factory CalendarLatestState.initial() {
    return const CalendarLatestState(
      latestEvent: null,
      status: CalendarLatestStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [latestEvent, status, failure];

  CalendarLatestState copyWith({
    Event? latestEvent,
    CalendarLatestStatus? status,
    Failure? failure,
  }) {
    return CalendarLatestState(
      latestEvent: latestEvent ?? this.latestEvent,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
