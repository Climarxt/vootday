import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:flutter/material.dart';

part 'explorer_event.dart';
part 'explorer_state.dart';

class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  ExplorerBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(ExplorerState.initial()) {
    on<ExplorerFetchPostsMan>(_mapExplorerFetchPostsManToState);
    on<ExplorerFetchPostsWoman>(_mapExplorerFetchPostsWomanToState);
  }

  Future<void> _mapExplorerFetchPostsManToState(
    ExplorerFetchPostsMan event,
    Emitter<ExplorerState> emit,
  ) async {
    try {
      debugPrint(
          'ExplorerFetchPostsMan : Fetching posts for user: ${_authBloc.state.user!.uid}');
      final posts = await _feedRepository.getFeedExplorerMan(
          userId: _authBloc.state.user!.uid);
      debugPrint(
          'ExplorerFetchPostsMan : Number of posts fetched: ${posts.length}');

      emit(
        state.copyWith(posts: posts, status: ExplorerStatus.loaded),
      );
      debugPrint('ExplorerFetchPostsMan : State emitted with loaded status');
    } catch (err) {
      debugPrint('ExplorerFetchPostsMan : Error in fetching posts: $err');
      emit(state.copyWith(
        status: ExplorerStatus.error,
        failure: const Failure(
            message:
                'ExplorerFetchPostsMan : Nous n\'avons pas pu charger votre flux'),
      ));
      debugPrint('ExplorerFetchPostsMan : State emitted with error status');
    }
  }

  Future<void> _mapExplorerFetchPostsWomanToState(
    ExplorerFetchPostsWoman event,
    Emitter<ExplorerState> emit,
  ) async {
    try {
      debugPrint(
          'ExplorerFetchPostsWoman : Fetching posts for user: ${_authBloc.state.user!.uid}');
      final posts = await _feedRepository.getFeedExplorerWoman(
          userId: _authBloc.state.user!.uid);
      debugPrint(
          'ExplorerFetchPostsWoman : Number of posts fetched: ${posts.length}');

      emit(
        state.copyWith(posts: posts, status: ExplorerStatus.loaded),
      );
      debugPrint('ExplorerFetchPostsWoman : State emitted with loaded status');
    } catch (err) {
      debugPrint('ExplorerFetchPostsWoman : Error in fetching posts: $err');
      emit(state.copyWith(
        status: ExplorerStatus.error,
        failure: const Failure(
            message:
                'ExplorerFetchPostsWoman : Nous n\'avons pas pu charger votre flux'),
      ));
      debugPrint('ExplorerFetchPostsWoman : State emitted with error status');
    }
  }
}
