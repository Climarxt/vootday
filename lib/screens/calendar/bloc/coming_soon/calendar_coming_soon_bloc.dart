import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calendar_coming_soon_event.dart';
part 'calendar_coming_soon_state.dart';

class CalendarComingSoonBloc
    extends Bloc<CalendarComingSoonEvent, CalendarComingSoonState> {
  final EventRepository _eventRepository;

  CalendarComingSoonBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(CalendarComingSoonState.initial()) {
    on<CalendarComingSoonFetchEvent>(_mapCalendarComingSoonFetchEvent);
  }

  Future<void> _mapCalendarComingSoonFetchEvent(
    CalendarComingSoonFetchEvent event,
    Emitter<CalendarComingSoonState> emit,
  ) async {
    try {
      debugPrint('CalendarComingSoonFetchEvent : Fetching this week events...');
      final thisComingSoonEvents = await _eventRepository.getComingSoonEvents();

      if (thisComingSoonEvents.isNotEmpty) {
        debugPrint(
            'CalendarComingSoonFetchEvent : This week events fetched successfully.');
        emit(state.copyWith(
            thisComingSoonEvents: thisComingSoonEvents,
            status: CalendarComingSoonStatus.loaded));
      } else {
        debugPrint(
            'CalendarComingSoonFetchEvent : No events found for this week.');
        emit(state.copyWith(
            thisComingSoonEvents: [],
            status: CalendarComingSoonStatus.noEvents));
      }
    } catch (err) {
      debugPrint('CalendarComingSoonFetchEvent : Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarComingSoonStatus.error,
        failure: const Failure(message: 'Unable to load the events'),
        thisComingSoonEvents: [],
      ));
    }
  }
}
