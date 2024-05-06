// ignore_for_file: unused_field

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'swipe_event_event.dart';
part 'swipe_event_state.dart';

class SwipeEventBloc extends Bloc<SwipeEventEvent, SwipeEventState> {
  final SwipeRepository _swipeRepository;
  final AuthBloc _authBloc;

  SwipeEventBloc({
    required SwipeRepository swipeRepository,
    required AuthBloc authBloc,
  })  : _swipeRepository = swipeRepository,
        _authBloc = authBloc,
        super(SwipeEventState.initial()) {
    on<SwipeEventWomanFetchPosts>(_onSwipeEventWomanFetchPosts);
    on<SwipeEventManFetchPosts>(_onSwipeEventManFetchPosts);
  }

  Future<void> _onSwipeEventWomanFetchPosts(
    SwipeEventWomanFetchPosts event,
    Emitter<SwipeEventState> emit,
  ) async {
    debugPrint(
        'SwipeEventWomanFetchPosts : Début de la récupération des posts OOTD');
    try {
      final userId = _authBloc.state.user!.uid;
      final posts = await _swipeRepository.getSwipeWoman(userId: userId);
      debugPrint(
          'SwipeEventWomanFetchPosts : Posts OOTD récupérés avec succès: ${posts.length} posts trouvés');
      emit(SwipeEventState.loaded(posts));
    } catch (e) {
      debugPrint(
          'SwipeEventWomanFetchPosts : Erreur lors du chargement des posts OOTD: ${e.toString()}');
      emit(SwipeEventState.error(
          'SwipeEventWomanFetchPosts : Erreur lors du chargement des posts: ${e.toString()}'));
    }
  }

  Future<void> _onSwipeEventManFetchPosts(
    SwipeEventManFetchPosts event,
    Emitter<SwipeEventState> emit,
  ) async {
    debugPrint(
        'SwipeEventManFetchPosts : Début de la récupération des posts OOTD');
    try {
      final userId = _authBloc.state.user!.uid;
      final posts = await _swipeRepository.getSwipeMan(userId: userId);
      debugPrint(
          'SwipeEventManFetchPosts : Posts OOTD récupérés avec succès: ${posts.length} posts trouvés');
      emit(SwipeEventState.loaded(posts));
    } catch (e) {
      debugPrint(
          'SwipeEventManFetchPosts : Erreur lors du chargement des posts OOTD: ${e.toString()}');
      emit(SwipeEventState.error(
          'SwipeEventManFetchPosts : Erreur lors du chargement des posts: ${e.toString()}'));
    }
  }
}
