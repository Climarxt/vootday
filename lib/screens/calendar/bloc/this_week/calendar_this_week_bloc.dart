import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calendar_this_week_event.dart';
part 'calendar_this_week_state.dart';

class CalendarThisWeekBloc
    extends Bloc<CalendarThisWeekEvent, CalendarThisWeekState> {
  final EventRepository _eventRepository;

  CalendarThisWeekBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(CalendarThisWeekState.initial()) {
    on<CalendarThisWeekFetchEvent>(_mapCalendarThisWeekFetchEvent);
  }

  Future<void> _mapCalendarThisWeekFetchEvent(
    CalendarThisWeekFetchEvent event,
    Emitter<CalendarThisWeekState> emit,
  ) async {
    try {
      debugPrint('CalendarThisWeekFetchEvent : Fetching this week events...');
      final thisWeekEvents = await _eventRepository.getThisWeekEvents();

      if (thisWeekEvents.isNotEmpty) {
        debugPrint(
            'CalendarThisWeekFetchEvent : This week events fetched successfully.');
        emit(state.copyWith(
            thisWeekEvents: thisWeekEvents,
            status: CalendarThisWeekStatus.loaded));
      } else {
        debugPrint('CalendarThisWeekFetchEvent : No events found for this week.');
        emit(state.copyWith(
            thisWeekEvents: [], status: CalendarThisWeekStatus.noEvents));
      }
    } catch (err) {
      debugPrint('CalendarThisWeekFetchEvent : Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarThisWeekStatus.error,
        failure: const Failure(message: 'Unable to load the events'),
        thisWeekEvents: [],
      ));
    }
  }
}
