// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_state_base.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/feed_ootd_city/feed_ootd_city_state.dart';
part 'package:bootdv2/screens/home/bloc/feed_ootd_city/feed_ootd_city_event.dart';

class FeedOOTDCityBloc extends Bloc<FeedOOTDCityEvent, FeedOOTDCityState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  FeedOOTDCityBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(FeedOOTDCityState.initial()) {
    on<FeedOOTDCityManFetchPostsByCity>(_mapFeedOOTDCityManFetchPostsByCity);
    on<FeedOOTDCityFemaleFetchPostsOOTD>(_mapFeedOOTDCityFemaleFetchPostsOOTD);
  }

  Future<void> _mapFeedOOTDCityManFetchPostsByCity(
    FeedOOTDCityManFetchPostsByCity event,
    Emitter<FeedOOTDCityState> emit,
  ) async {
    try {
      final posts = await _feedRepository.getFeedOOTDManCity(
        userId: _authBloc.state.user!.uid,
        locationCountry: event.locationCountry,
        locationState: event.locationState,
        locationCity: event.locationCity,
      );

      emit(
        state.copyWith(posts: posts, status: FeedOOTDCityStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDCityStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedOOTDCityFemaleFetchPostsOOTD(
    FeedOOTDCityFemaleFetchPostsOOTD event,
    Emitter<FeedOOTDCityState> emit,
  ) async {
    try {
      final posts = await _feedRepository.getFeedOOTDFemale(
        userId: _authBloc.state.user!.uid,
      );

      emit(
        state.copyWith(posts: posts, status: FeedOOTDCityStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDCityStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }
}
