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
    on<SwipeFetchPostsOOTD>(_onSwipeFetchPostsOOTD);
  }

  Future<void> _onSwipeFetchPostsOOTD(
    SwipeFetchPostsOOTD event,
    Emitter<SwipeState> emit,
  ) async {
    debugPrint('_onSwipeFetchPostsOOTD : Début de la récupération des posts OOTD');
    try {
      final posts = await _swipeRepository.getSwipeOOTD();
      debugPrint(
          '_onSwipeFetchPostsOOTD : Posts OOTD récupérés avec succès: ${posts.length} posts trouvés');
      emit(SwipeState.loaded(posts));
    } catch (e) {
      debugPrint('_onSwipeFetchPostsOOTD : Erreur lors du chargement des posts OOTD: ${e.toString()}');
      emit(SwipeState.error(
          '_onSwipeFetchPostsOOTD : Erreur lors du chargement des posts: ${e.toString()}'));
    }
  }
}
