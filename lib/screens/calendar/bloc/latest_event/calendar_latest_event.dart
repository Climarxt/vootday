part of 'calendar_latest_bloc.dart';

abstract class CalendarLatestEventEvent extends Equatable {
  const CalendarLatestEventEvent();

  @override
  List<Object?> get props => [];
}

class CalendarLatestEventFetchEvent extends CalendarLatestEventEvent {}
