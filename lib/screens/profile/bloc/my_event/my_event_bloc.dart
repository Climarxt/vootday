import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/profile/bloc/my_event/my_event_event.dart';
part 'package:bootdv2/screens/profile/bloc/my_event/my_event_state.dart';

class MyEventBloc extends Bloc<MyEventEvent, MyEventState> {
  final EventRepository _eventRepository;
  final AuthBloc _authBloc;

  MyEventBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        _authBloc = authBloc,
        super(MyEventState.initial()) {
    on<MyEventFetchEvents>(_mapMyEventFetchEvents);
  }

  Future<void> _mapMyEventFetchEvents(
    MyEventFetchEvents event,
    Emitter<MyEventState> emit,
  ) async {
    try {
      debugPrint('Method _mapMyEventFetchEventsToState : Fetching events...');
      final events = await _eventRepository.getEventsDone(
        userId: _authBloc.state.user!.uid,
      );

      if (events.isEmpty) {
        debugPrint('Method _mapMyEventFetchEventsToState : No events found.');
      } else {
        debugPrint(
            'Method _mapMyEventFetchEventsToState : Events fetched successfully. Total events: ${events.length}');
      }

      emit(
        state.copyWith(events: events, status: MyEventStatus.loaded),
      );
    } catch (err) {
      // Le log ici vous donnera des détails sur l'exception attrapée
      debugPrint(
          'Method _mapMyEventFetchEventsToState : Error fetching events: ${err.toString()}');

      emit(state.copyWith(
        status: MyEventStatus.error,
        failure: const Failure(
            message:
                'Method _mapMyEventFetchEventsToState : Impossible de charger les événements'),
        events: [],
      ));
    }
  }
}
