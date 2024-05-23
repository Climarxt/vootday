// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_event.dart';
part 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_state.dart';

class FeedOOTDBloc extends Bloc<FeedOOTDEvent, FeedOOTDState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  FeedOOTDBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(FeedOOTDState.initial()) {
    on<FeedOOTDManFetchPostsOOTD>(_mapFeedOOTDManFetchPostsOOTD);
    on<FeedOOTDFemaleFetchPostsOOTD>(_mapFeedOOTDFemaleFetchPostsOOTD);
  }

  Future<void> _mapFeedOOTDManFetchPostsOOTD(
    FeedOOTDManFetchPostsOOTD event,
    Emitter<FeedOOTDState> emit,
  ) async {
    try {
      final posts = await _feedRepository.getFeedOOTDMan(
          userId: _authBloc.state.user!.uid);

      emit(
        state.copyWith(posts: posts, status: FeedOOTDStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedOOTDFemaleFetchPostsOOTD(
    FeedOOTDFemaleFetchPostsOOTD event,
    Emitter<FeedOOTDState> emit,
  ) async {
    try {
      final posts = await _feedRepository.getFeedOOTDFemale(
          userId: _authBloc.state.user!.uid);

      emit(
        state.copyWith(posts: posts, status: FeedOOTDStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }
}
