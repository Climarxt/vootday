import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';

part 'package:bootdv2/screens/home/bloc/feed_month/feed_month_state.dart';
part 'package:bootdv2/screens/home/bloc/feed_month/feed_month_event.dart';

class FeedMonthBloc extends Bloc<FeedMonthEvent, FeedMonthState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  FeedMonthBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(FeedMonthState.initial()) {
    on<FeedMonthFetchPostsMonth>(_mapFeedMonthFetchPostsMonth);
    on<FeedMonthFetchPosts>(_mapFeedMonthFetchPostsToState);
    on<FeedMonthPaginatePosts>(_mapFeedMonthPaginatePostsToState);
  }

  Future<void> _mapFeedMonthFetchPostsMonth(
    FeedMonthFetchPostsMonth event,
    Emitter<FeedMonthState> emit,
  ) async {
    debugPrint(
        '_mapFeedMonthFetchPostsMonth : Début de _mapFeedMonthFetchPostsMonth');
    try {
      final userId = _authBloc.state.user!.uid;
      debugPrint(
          '_mapFeedMonthFetchPostsMonth : Récupération des posts pour l\'utilisateur : $userId');

      final posts = await _feedRepository.getFeedMonth(userId: userId);
      debugPrint(
          '_mapFeedMonthFetchPostsMonth : Posts récupérés : ${posts.length}');

      emit(
        state.copyWith(posts: posts, status: FeedMonthStatus.loaded),
      );
      debugPrint(
          '_mapFeedMonthFetchPostsMonth : État mis à jour avec les nouveaux posts');
    } catch (err) {
      debugPrint(
          '_mapFeedMonthFetchPostsMonth : Erreur lors de la récupération des posts : $err');
      emit(state.copyWith(
        status: FeedMonthStatus.error,
        failure: const Failure(
            message:
                '_mapFeedMonthFetchPostsMonth : Nous n\'avons pas pu charger votre flux'),
      ));
    }
    debugPrint(
        '_mapFeedMonthFetchPostsMonth : Fin de _mapFeedMonthFetchPostsMonth');
  }

  Future<void> _mapFeedMonthFetchPostsToState(
    FeedMonthFetchPosts event,
    Emitter<FeedMonthState> emit,
  ) async {
    try {
      final posts =
          await _feedRepository.getFeedMonth(userId: _authBloc.state.user!.uid);

      emit(
        state.copyWith(posts: posts, status: FeedMonthStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedMonthStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedMonthPaginatePostsToState(
    FeedMonthPaginatePosts event,
    Emitter<FeedMonthState> emit,
  ) async {
    emit(state.copyWith(status: FeedMonthStatus.paginating));
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last!.id : null;

      final posts = await _feedRepository.getFeedMonth(
        userId: _authBloc.state.user!.uid,
        lastPostId: lastPostId,
      );
      final updatedPosts = List<Post?>.from(state.posts)..addAll(posts);

      emit(
        state.copyWith(posts: updatedPosts, status: FeedMonthStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedMonthStatus.error,
        failure: const Failure(
            message: 'Quelque chose s\'est mal passé ! Veuillez réessayer.'),
      ));
    }
  }
}
