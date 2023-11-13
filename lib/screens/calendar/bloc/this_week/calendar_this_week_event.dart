part of 'calendar_this_week_bloc.dart';

abstract class CalendarThisWeekEvent extends Equatable {
  const CalendarThisWeekEvent();

  @override
  List<Object?> get props => [];
}

class CalendarThisWeekFetchEvent extends CalendarThisWeekEvent {}
