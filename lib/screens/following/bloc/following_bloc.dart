// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';

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
    on<FollowingFetchPosts>(_mapFollowingFetchPostsOOTD);
  }

  Future<void> _mapFollowingFetchPostsOOTD(
    FollowingFetchPosts event,
    Emitter<FollowingState> emit,
  ) async {
    try {
      final posts =
          await _feedRepository.getFeedFollowing(userId: _authBloc.state.user!.uid);

      emit(
        state.copyWith(posts: posts, status: FollowingStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FollowingStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }
}
