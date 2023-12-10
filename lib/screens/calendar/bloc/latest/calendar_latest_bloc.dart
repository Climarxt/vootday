import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calendar_latest_event.dart';
part 'calendar_latest_state.dart';

class CalendarLatestBloc
    extends Bloc<CalendarLatestEvent, CalendarLatestState> {
  final EventRepository _eventRepository;

  CalendarLatestBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        super(CalendarLatestState.initial()) {
    on<CalendarLatestFetchEvent>(_mapCalendarLatestFetchEvent);
  }

  Future<void> _mapCalendarLatestFetchEvent(
    CalendarLatestFetchEvent event,
    Emitter<CalendarLatestState> emit,
  ) async {
    try {
      debugPrint('CalendarLatestFetchEvent : Fetching latest event...');
      final latestEvent = await _eventRepository.getLatestEvent();
      if (latestEvent != null) {
        debugPrint(
            'CalendarLatestFetchEvent : Latest event fetched successfully.');
        emit(state.copyWith(
            latestEvent: latestEvent, status: CalendarLatestStatus.loaded));
      } else {
        debugPrint('CalendarLatestFetchEvent : No events found.');
        emit(state.copyWith(
            latestEvent: null, status: CalendarLatestStatus.noEvents));
      }
    } catch (err) {
      debugPrint('CalendarLatestFetchEvent : Error fetching event - $err');
      emit(state.copyWith(
        status: CalendarLatestStatus.error,
        failure: const Failure(message: 'Unable to load the event'),
      ));
    }
  }
}
