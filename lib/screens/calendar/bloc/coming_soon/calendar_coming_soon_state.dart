part of 'calendar_coming_soon_bloc.dart';

enum CalendarComingSoonStatus { initial, loading, loaded, noEvents, error }

class CalendarComingSoonState extends Equatable {
  final List<Event?> thisComingSoonEvents;
  final CalendarComingSoonStatus status;
  final Failure failure;

  const CalendarComingSoonState({
    required this.thisComingSoonEvents,
    required this.status,
    required this.failure,
  });

  factory CalendarComingSoonState.initial() {
    return const CalendarComingSoonState(
      thisComingSoonEvents: [],
      status: CalendarComingSoonStatus.initial,
      failure: Failure(),
    );
  }

  factory CalendarComingSoonState.loading() {
    return const CalendarComingSoonState(
      thisComingSoonEvents: [],
      status: CalendarComingSoonStatus.loading, // Change this to `.loading`
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [thisComingSoonEvents, status, failure];

  CalendarComingSoonState copyWith({
    List<Event?>? thisComingSoonEvents,
    CalendarComingSoonStatus? status,
    Failure? failure,
  }) {
    return CalendarComingSoonState(
      thisComingSoonEvents: thisComingSoonEvents ?? this.thisComingSoonEvents,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
