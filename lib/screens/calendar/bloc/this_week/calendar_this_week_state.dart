part of 'calendar_this_week_bloc.dart';

enum CalendarThisWeekStatus { initial, loading, loaded, noEvents, error }

class CalendarThisWeekState extends Equatable {
  final List<Event?> thisWeekEvents;
  final CalendarThisWeekStatus status;
  final Failure failure;

  const CalendarThisWeekState({
    required this.thisWeekEvents,
    required this.status,
    required this.failure,
  });

  factory CalendarThisWeekState.initial() {
    return const CalendarThisWeekState(
      thisWeekEvents: [],
      status: CalendarThisWeekStatus.initial,
      failure: Failure(),
    );
  }

  factory CalendarThisWeekState.loading() {
    return const CalendarThisWeekState(
      thisWeekEvents: [],
      status: CalendarThisWeekStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [thisWeekEvents, status, failure];

  CalendarThisWeekState copyWith({
    List<Event?>? thisWeekEvents,
    CalendarThisWeekStatus? status,
    Failure? failure,
  }) {
    return CalendarThisWeekState(
      thisWeekEvents: thisWeekEvents ?? this.thisWeekEvents,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
