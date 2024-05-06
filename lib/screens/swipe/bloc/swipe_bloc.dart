// ignore_for_file: unused_field

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final SwipeRepository _swipeRepository;
  final AuthBloc _authBloc;

  SwipeBloc({
    required SwipeRepository swipeRepository,
    required AuthBloc authBloc,
  })  : _swipeRepository = swipeRepository,
        _authBloc = authBloc,
        super(SwipeState.initial()) {
    on<SwipeFetchPostsOOTDWoman>(_onSwipeFetchPostsOOTDWoman);
    on<SwipeFetchPostsOOTDMan>(_onSwipeFetchPostsOOTDMan);
  }

  Future<void> _onSwipeFetchPostsOOTDWoman(
    SwipeFetchPostsOOTDWoman event,
    Emitter<SwipeState> emit,
  ) async {
    debugPrint(
        'SwipeFetchPostsOOTDWoman : Début de la récupération des posts OOTD');
    try {
      final userId = _authBloc.state.user!.uid;
      final posts = await _swipeRepository.getSwipeWoman(userId: userId);
      debugPrint(
          'SwipeFetchPostsOOTDWoman : Posts OOTD récupérés avec succès: ${posts.length} posts trouvés');
      emit(SwipeState.loaded(posts));
    } catch (e) {
      debugPrint(
          'SwipeFetchPostsOOTDWoman : Erreur lors du chargement des posts OOTD: ${e.toString()}');
      emit(SwipeState.error(
          'SwipeFetchPostsOOTDWoman : Erreur lors du chargement des posts: ${e.toString()}'));
    }
  }

  Future<void> _onSwipeFetchPostsOOTDMan(
    SwipeFetchPostsOOTDMan event,
    Emitter<SwipeState> emit,
  ) async {
    debugPrint(
        'SwipeFetchPostsOOTDMan : Début de la récupération des posts OOTD');
    try {
      final userId = _authBloc.state.user!.uid;
      final posts = await _swipeRepository.getSwipeMan(userId: userId);
      debugPrint(
          'SwipeFetchPostsOOTDMan : Posts OOTD récupérés avec succès: ${posts.length} posts trouvés');
      emit(SwipeState.loaded(posts));
    } catch (e) {
      debugPrint(
          'SwipeFetchPostsOOTDMan : Erreur lors du chargement des posts OOTD: ${e.toString()}');
      emit(SwipeState.error(
          'SwipeFetchPostsOOTDMan : Erreur lors du chargement des posts: ${e.toString()}'));
    }
  }
}
