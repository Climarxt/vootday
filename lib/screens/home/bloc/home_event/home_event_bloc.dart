import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/models/event_model.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/home_event/home_event_event.dart';
part 'package:bootdv2/screens/home/bloc/home_event/home_event_state.dart';

class HomeEventBloc extends Bloc<HomeEventEvent, HomeEventState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  HomeEventBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(HomeEventState.initial()) {
    on<HomeEventFetchEvents>(_mapHomeEventFetchEventsToState);
  }

  Future<void> _mapHomeEventFetchEventsToState(
    HomeEventFetchEvents event,
    Emitter<HomeEventState> emit,
  ) async {
    try {
      print('Fetching events...');
      final events = await _postRepository.getEvents();

      if (events.isEmpty) {
        print('No events found.');
      } else {
        print('Events fetched successfully. Total events: ${events.length}');
      }

      emit(
        state.copyWith(events: events, status: HomeEventStatus.loaded),
      );
    } catch (err) {
      // Le log ici vous donnera des détails sur l'exception attrapée
      print('Error fetching events: ${err.toString()}');

      emit(state.copyWith(
        status: HomeEventStatus.error,
        failure: const Failure(message: 'Impossible de charger les événements'),
        events: [],
      ));
    }
  }
}
