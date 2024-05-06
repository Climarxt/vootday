part of 'home_event_bloc.dart';

abstract class HomeEventEvent extends Equatable {
  const HomeEventEvent();

  @override
  List<Object?> get props => [];
}


class HomeEventManFetchEvents extends HomeEventEvent {}

class HomeEventWomanFetchEvents extends HomeEventEvent {}