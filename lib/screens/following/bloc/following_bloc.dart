import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:flutter/material.dart';

part 'following_event.dart';
part 'following_state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  FollowingBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(FollowingState.initial()) {
    on<FollowingFetchPosts>(_mapFollowingFetchPostsToState);
  }
  Future<void> _mapFollowingFetchPostsToState(
    FollowingFetchPosts event,
    Emitter<FollowingState> emit,
  ) async {
    try {
      debugPrint('FollowingFetchPosts : Fetching posts for user: ${_authBloc.state.user!.uid}');
      final posts =
          await _feedRepository.getUserFeed(userId: _authBloc.state.user!.uid);
      debugPrint('FollowingFetchPosts : Number of posts fetched: ${posts.length}');

      emit(
        state.copyWith(posts: posts, status: FollowingStatus.loaded),
      );
      debugPrint('FollowingFetchPosts : State emitted with loaded status');
    } catch (err) {
      debugPrint('FollowingFetchPosts : Error in fetching posts: $err');
      emit(state.copyWith(
        status: FollowingStatus.error,
        failure:
            const Failure(message: 'FollowingFetchPosts : Nous n\'avons pas pu charger votre flux'),
      ));
      debugPrint('FollowingFetchPosts : State emitted with error status');
    }
  }
}
