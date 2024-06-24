// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_state_base.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/feed_ootd_state/feed_ootd_state_state.dart';
part 'package:bootdv2/screens/home/bloc/feed_ootd_state/feed_ootd_state_event.dart';

class FeedOOTDStateBloc extends Bloc<FeedOOTDStateEvent, FeedOOTDStateState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  FeedOOTDStateBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(FeedOOTDStateState.initial()) {
    on<FeedOOTDStateManFetchPostsByState>(
        _mapFeedOOTDStateManFetchPostsByState);
    on<FeedOOTDStateFemaleFetchPostsOOTD>(
        _mapFeedOOTDStateFemaleFetchPostsOOTD);
  }

  Future<void> _mapFeedOOTDStateManFetchPostsByState(
    FeedOOTDStateManFetchPostsByState event,
    Emitter<FeedOOTDStateState> emit,
  ) async {
    try {
      final posts = await _feedRepository.getFeedOOTDManState(
        userId: _authBloc.state.user!.uid,
        locationCountry: event.locationCountry,
        locationState: event.locationState,
      );

      emit(
        state.copyWith(posts: posts, status: FeedOOTDStateStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDStateStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedOOTDStateFemaleFetchPostsOOTD(
    FeedOOTDStateFemaleFetchPostsOOTD event,
    Emitter<FeedOOTDStateState> emit,
  ) async {
    try {
      final posts = await _feedRepository.getFeedOOTDFemale(
        userId: _authBloc.state.user!.uid,
      );

      emit(
        state.copyWith(posts: posts, status: FeedOOTDStateStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDStateStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }
}
