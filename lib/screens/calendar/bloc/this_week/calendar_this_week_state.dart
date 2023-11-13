part of 'calendar_this_week_bloc.dart';

enum CalendarThisWeekStatus { initial, loading, loaded, noEvents, error }

class CalendarThisWeekEventState extends Equatable {
  final Event? latestEvent;
  final CalendarThisWeekStatus status;
  final Failure failure;

  const CalendarThisWeekEventState({
    this.latestEvent,
    required this.status,
    required this.failure,
  });

  factory CalendarThisWeekEventState.initial() {
    return const CalendarThisWeekEventState(
      latestEvent: null,
      status: CalendarThisWeekStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [latestEvent, status, failure];

  CalendarThisWeekEventState copyWith({
    Event? latestEvent,
    CalendarThisWeekStatus? status,
    Failure? failure,
  }) {
    return CalendarThisWeekEventState(
      latestEvent: latestEvent ?? this.latestEvent,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
