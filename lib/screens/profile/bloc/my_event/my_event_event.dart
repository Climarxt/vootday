part of 'my_event_bloc.dart';

abstract class MyEventEvent extends Equatable {
  const MyEventEvent();

  @override
  List<Object?> get props => [];
}

class MyEventFetchEvents extends MyEventEvent {
  final String userId;

  const MyEventFetchEvents({required this.userId});

  @override
  List<Object> get props => [userId];
}
