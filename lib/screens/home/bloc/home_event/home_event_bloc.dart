import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/event_model.dart';
import 'package:equatable/equatable.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/home_event/home_event_event.dart';
part 'package:bootdv2/screens/home/bloc/home_event/home_event_state.dart';

class HomeEventBloc extends Bloc<HomeEventEvent, HomeEventState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  HomeEventBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(HomeEventState.initial()) {
    on<HomeEventFetchEvents>(_mapHomeEventFetchEventsToState);
    on<HomeEventPaginateEvents>(_mapHomeEventPaginateEventsToState);
  }

  Future<void> _mapHomeEventFetchEventsToState(
    HomeEventFetchEvents event,
    Emitter<HomeEventState> emit,
  ) async {
    try {
      print('Method _mapHomeEventFetchEventsToState : Fetching events...');
      final events = await _postRepository.getEvents(
        userId: _authBloc.state.user!.uid,
      );

      if (events.isEmpty) {
        print('Method _mapHomeEventFetchEventsToState : No events found.');
      } else {
        print(
            'Method _mapHomeEventFetchEventsToState : Events fetched successfully. Total events: ${events.length}');
      }

      emit(
        state.copyWith(events: events, status: HomeEventStatus.loaded),
      );
    } catch (err) {
      // Le log ici vous donnera des détails sur l'exception attrapée
      print(
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

  Future<void> _mapHomeEventPaginateEventsToState(
    HomeEventPaginateEvents event,
    Emitter<HomeEventState> emit,
  ) async {
    print('HomeEventPaginateEvents:  Pagination started.');
    emit(state.copyWith(status: HomeEventStatus.paginating));

    try {
      final String? lastEventId =
          state.events.isNotEmpty ? state.events.last!.id : null;
      print('HomeEventPaginateEvents:  Last event ID is $lastEventId');

      final List<Event?> events = await _postRepository.getEvents(
        userId: _authBloc.state.user!.uid,
        lastEventId: lastEventId,
      );
      print('HomeEventPaginateEvents:  Fetched ${events.length} more events.');

      final List<Event?> updatedEvents = List<Event?>.from(state.events)
        ..addAll(events);
      print(
          'HomeEventPaginateEvents:  Total events after pagination: ${updatedEvents.length}');

      emit(state.copyWith(
          events: updatedEvents, status: HomeEventStatus.loaded));
    } catch (err) {
      print('HomeEventPaginateEvents:  Error during pagination - ${err.toString()}');

      emit(state.copyWith(
        status: HomeEventStatus.error,
        failure: const Failure(
          message: 'Something went wrong! Please try again.',
        ),
      ));
    }
  }
}
