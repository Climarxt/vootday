part of 'calendar_latest_bloc.dart';

abstract class CalendarLatestEvent extends Equatable {
  const CalendarLatestEvent();

  @override
  List<Object?> get props => [];
}

class CalendarLatestFetchEvent extends CalendarLatestEvent {}
