part of 'calendar_coming_soon_bloc.dart';

abstract class CalendarComingSoonEvent extends Equatable {
  const CalendarComingSoonEvent();

  @override
  List<Object?> get props => [];
}

class CalendarComingSoonFetchEvent extends CalendarComingSoonEvent {}
