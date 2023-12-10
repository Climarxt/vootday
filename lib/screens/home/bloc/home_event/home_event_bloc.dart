import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
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
    on<HomeEventFetchEvents>(_mapHomeEventFetchEvents);
  }

  Future<void> _mapHomeEventFetchEvents(
    HomeEventFetchEvents event,
    Emitter<HomeEventState> emit,
  ) async {
    try {
      print('Method _mapHomeEventFetchEventsToState : Fetching events...');
      final events = await _postRepository.getEventsDone(
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
}
