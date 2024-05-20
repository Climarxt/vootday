import 'package:bloc/bloc.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;

  EventBloc({
    required EventRepository eventRepository,
  })  : _eventRepository = eventRepository,
        super(EventState.initial()) {
    on<EventFetchEvent>(_mapEventFetchEvent);
    on<EventClean>(_onEventClean);
  }

  Future<void> _mapEventFetchEvent(
    EventFetchEvent fetchEvent,
    Emitter<EventState> emit,
  ) async {
    _onEventClean(EventClean(), emit);
    try {
      debugPrint('EventBloc: Fetching event ${fetchEvent.eventId}...');
      final Event? eventDetails =
          await _eventRepository.getEventById(fetchEvent.eventId);
      if (eventDetails != null) {
        debugPrint('EventBloc: Event ${fetchEvent.eventId} fetched successfully.');
        emit(state.copyWith(event: eventDetails, status: EventStatus.loaded));
      } else {
        debugPrint('EventBloc: Event ${fetchEvent.eventId} not found.');
        emit(state.copyWith(event: null, status: EventStatus.noEvents));
      }
    } catch (err) {
      debugPrint('EventBloc: Error fetching event - $err');
      emit(state.copyWith(
        status: EventStatus.error,
        failure: Failure(message: 'Unable to load the event - $err'),
      ));
    }
  }

  Future<void> _onEventClean(
    EventClean event,
    Emitter<EventState> emit,
  ) async {
    emit(EventState.initial());
  }
}
