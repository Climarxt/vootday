part of 'my_event_bloc.dart';

enum MyEventStatus { initial, loading, loaded, paginating, error }

class MyEventState extends Equatable {
  final List<Event?> events;
  final MyEventStatus status;
  final Failure failure;

  const MyEventState({
    required this.events,
    required this.status,
    required this.failure,
  });

  factory MyEventState.initial() {
    return const MyEventState(
      events: [],
      status: MyEventStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [events, status, failure];

  MyEventState copyWith(
      {List<Event?>? events, MyEventStatus? status, Failure? failure}) {
    return MyEventState(
      events: events ?? this.events,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
