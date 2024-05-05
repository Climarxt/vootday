import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
    on<FeedMonthManFetchPostsMonth>(_mapFeedMonthManFetchPostsMonth);
    on<FeedMonthFemaleFetchPostsMonth>(_mapFeedMonthFemaleFetchPostsMonth);
  }

  Future<void> _mapFeedMonthManFetchPostsMonth(
    FeedMonthManFetchPostsMonth event,
    Emitter<FeedMonthState> emit,
  ) async {
    debugPrint(
        '_mapFeedMonthManFetchPostsMonth : Début de _mapFeedMonthManFetchPostsMonth');
    try {
      final userId = _authBloc.state.user!.uid;
      debugPrint(
          '_mapFeedMonthManFetchPostsMonth : Récupération des posts pour l\'utilisateur : $userId');

      final posts = await _feedRepository.getFeedMonthMan(userId: userId);
      debugPrint(
          '_mapFeedMonthManFetchPostsMonth : Posts récupérés : ${posts.length}');

      emit(
        state.copyWith(posts: posts, status: FeedMonthStatus.loaded),
      );
      debugPrint(
          '_mapFeedMonthManFetchPostsMonth : État mis à jour avec les nouveaux posts');
    } catch (err) {
      debugPrint(
          '_mapFeedMonthManFetchPostsMonth : Erreur lors de la récupération des posts : $err');
      emit(state.copyWith(
        status: FeedMonthStatus.error,
        failure: const Failure(
            message:
                '_mapFeedMonthManFetchPostsMonth : Nous n\'avons pas pu charger votre flux'),
      ));
    }
    debugPrint(
        '_mapFeedMonthManFetchPostsMonth : Fin de _mapFeedMonthManFetchPostsMonth');
  }

  Future<void> _mapFeedMonthFemaleFetchPostsMonth(
    FeedMonthFemaleFetchPostsMonth event,
    Emitter<FeedMonthState> emit,
  ) async {
    debugPrint(
        '_mapFeedMonthFemaleFetchPostsMonth : Début de _mapFeedMonthFemaleFetchPostsMonth');
    try {
      final userId = _authBloc.state.user!.uid;
      debugPrint(
          '_mapFeedMonthFemaleFetchPostsMonth : Récupération des posts pour l\'utilisateur : $userId');

      final posts = await _feedRepository.getFeedMonthFemale(userId: userId);
      debugPrint(
          '_mapFeedMonthFemaleFetchPostsMonth : Posts récupérés : ${posts.length}');

      emit(
        state.copyWith(posts: posts, status: FeedMonthStatus.loaded),
      );
      debugPrint(
          '_mapFeedMonthFemaleFetchPostsMonth : État mis à jour avec les nouveaux posts');
    } catch (err) {
      debugPrint(
          '_mapFeedMonthFemaleFetchPostsMonth : Erreur lors de la récupération des posts : $err');
      emit(state.copyWith(
        status: FeedMonthStatus.error,
        failure: const Failure(
            message:
                '_mapFeedMonthFemaleFetchPostsMonth : Nous n\'avons pas pu charger votre flux'),
      ));
    }
    debugPrint(
        '_mapFeedMonthFemaleFetchPostsMonth : Fin de _mapFeedMonthFemaleFetchPostsMonth');
  }
}
