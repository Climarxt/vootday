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
}
