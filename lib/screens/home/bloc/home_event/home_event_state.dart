part of 'home_event_bloc.dart';

enum HomeEventStatus { initial, loading, loaded, paginating, error }

class HomeEventState extends Equatable {
  final List<Event?> events;
  final HomeEventStatus status;
  final Failure failure;

  const HomeEventState({
    required this.events,
    required this.status,
    required this.failure,
  });

  factory HomeEventState.initial() {
    return const HomeEventState(
      events: [],
      status: HomeEventStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [events, status, failure];

  HomeEventState copyWith({
    List<Event?>? events,
    HomeEventStatus? status,
    Failure? failure
  }) {
    return HomeEventState(
      events: events ?? this.events,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
