import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/models/event_model.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/event/home_event_event.dart';
part 'package:bootdv2/screens/home/bloc/event/home_event_state.dart';

class FeedEventBloc extends Bloc<FeedEventEvent, FeedEventState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  FeedEventBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FeedEventState.initial()) {
    on<FeedEventFetchEvents>(_mapFeedEventFetchEventsToState);
  }

  Future<void> _mapFeedEventFetchEventsToState(
    FeedEventFetchEvents event,
    Emitter<FeedEventState> emit,
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
        state.copyWith(events: events, status: FeedEventStatus.loaded),
      );
    } catch (err) {
      // Le log ici vous donnera des détails sur l'exception attrapée
      print('Error fetching events: ${err.toString()}');

      emit(state.copyWith(
        status: FeedEventStatus.error,
        failure: const Failure(message: 'Impossible de charger les événements'),
        events: [],
      ));
    }
  }
}
