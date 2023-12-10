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
    on<ExplorerFetchPosts>(_mapExplorerFetchPostsToState);
  }
  Future<void> _mapExplorerFetchPostsToState(
    ExplorerFetchPosts event,
    Emitter<ExplorerState> emit,
  ) async {
    try {
      debugPrint(
          'ExplorerFetchPosts : Fetching posts for user: ${_authBloc.state.user!.uid}');
      final posts = await _feedRepository.getFeedExplorer(
          userId: _authBloc.state.user!.uid);
      debugPrint(
          'ExplorerFetchPosts : Number of posts fetched: ${posts.length}');

      emit(
        state.copyWith(posts: posts, status: ExplorerStatus.loaded),
      );
      debugPrint('ExplorerFetchPosts : State emitted with loaded status');
    } catch (err) {
      debugPrint('ExplorerFetchPosts : Error in fetching posts: $err');
      emit(state.copyWith(
        status: ExplorerStatus.error,
        failure: const Failure(
            message:
                'ExplorerFetchPosts : Nous n\'avons pas pu charger votre flux'),
      ));
      debugPrint('ExplorerFetchPosts : State emitted with error status');
    }
  }
}
