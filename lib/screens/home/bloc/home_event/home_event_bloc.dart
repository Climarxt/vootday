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
    on<HomeEventManFetchEvents>(_mapHomeEventManFetchEvents);
    on<HomeEventWomanFetchEvents>(_mapHomeEventWomanFetchEvents);
  }

  Future<void> _mapHomeEventManFetchEvents(
    HomeEventManFetchEvents event,
    Emitter<HomeEventState> emit,
  ) async {
    try {
      debugPrint('HomeEventManFetchEvents : Fetching events...');
      final events = await _eventRepository.getEventsManDone(
        userId: _authBloc.state.user!.uid,
      );

      if (events.isEmpty) {
        debugPrint('HomeEventManFetchEvents : No events found.');
      } else {
        debugPrint(
            'HomeEventManFetchEvents : Events fetched successfully. Total events: ${events.length}');
      }

      emit(
        state.copyWith(events: events, status: HomeEventStatus.loaded),
      );
    } catch (err) {
      // Le log ici vous donnera des détails sur l'exception attrapée
      debugPrint(
          'HomeEventManFetchEvents : Error fetching events: ${err.toString()}');

      emit(state.copyWith(
        status: HomeEventStatus.error,
        failure: const Failure(
            message:
                'HomeEventManFetchEvents : Impossible de charger les événements'),
        events: [],
      ));
    }
  }

  Future<void> _mapHomeEventWomanFetchEvents(
    HomeEventWomanFetchEvents event,
    Emitter<HomeEventState> emit,
  ) async {
    try {
      debugPrint('HomeEventWomanFetchEvents : Fetching events...');
      final events = await _eventRepository.getEventsWomanDone(
        userId: _authBloc.state.user!.uid,
      );

      if (events.isEmpty) {
        debugPrint('HomeEventWomanFetchEvents : No events found.');
      } else {
        debugPrint(
            'HomeEventWomanFetchEvents : Events fetched successfully. Total events: ${events.length}');
      }

      emit(
        state.copyWith(events: events, status: HomeEventStatus.loaded),
      );
    } catch (err) {
      // Le log ici vous donnera des détails sur l'exception attrapée
      debugPrint(
          'HomeEventWomanFetchEvents : Error fetching events: ${err.toString()}');

      emit(state.copyWith(
        status: HomeEventStatus.error,
        failure: const Failure(
            message:
                'HomeEventWomanFetchEvents : Impossible de charger les événements'),
        events: [],
      ));
    }
  }
}
