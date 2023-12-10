import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/home_event/home_event_event.dart';
part 'package:bootdv2/screens/home/bloc/home_event/home_event_state.dart';

class HomeEventBloc extends Bloc<HomeEventEvent, HomeEventState> {
  final EventRepository _eventRepository;
  final AuthBloc _authBloc;

  HomeEventBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        _authBloc = authBloc,
        super(HomeEventState.initial()) {
    on<HomeEventFetchEvents>(_mapHomeEventFetchEvents);
  }

  Future<void> _mapHomeEventFetchEvents(
    HomeEventFetchEvents event,
    Emitter<HomeEventState> emit,
  ) async {
    try {
      debugPrint('Method _mapHomeEventFetchEventsToState : Fetching events...');
      final events = await _eventRepository.getEventsDone(
        userId: _authBloc.state.user!.uid,
      );

      if (events.isEmpty) {
        debugPrint('Method _mapHomeEventFetchEventsToState : No events found.');
      } else {
        debugPrint(
            'Method _mapHomeEventFetchEventsToState : Events fetched successfully. Total events: ${events.length}');
      }

      emit(
        state.copyWith(events: events, status: HomeEventStatus.loaded),
      );
    } catch (err) {
      // Le log ici vous donnera des détails sur l'exception attrapée
      debugPrint(
          'Method _mapHomeEventFetchEventsToState : Error fetching events: ${err.toString()}');

      emit(state.copyWith(
        status: HomeEventStatus.error,
        failure: const Failure(
            message:
                'Method _mapHomeEventFetchEventsToState : Impossible de charger les événements'),
        events: [],
      ));
    }
  }
}
