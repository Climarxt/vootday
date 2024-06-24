// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_state_base.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/feed_ootd_country/feed_ootd_country_state.dart';
part 'package:bootdv2/screens/home/bloc/feed_ootd_country/feed_ootd_country_event.dart';

class FeedOOTDCountryBloc
    extends Bloc<FeedOOTDCountryEvent, FeedOOTDCountryState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  FeedOOTDCountryBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(FeedOOTDCountryState.initial()) {
    on<FeedOOTDCountryManFetchPostsByCountry>(
        _mapFeedOOTDCountryManFetchPostsByCountry);
    on<FeedOOTDCountryFemaleFetchPostsOOTD>(
        _mapFeedOOTDCountryFemaleFetchPostsOOTD);
  }

  Future<void> _mapFeedOOTDCountryManFetchPostsByCountry(
    FeedOOTDCountryManFetchPostsByCountry event,
    Emitter<FeedOOTDCountryState> emit,
  ) async {
    try {
      final posts = await _feedRepository.getFeedOOTDManCountry(
        userId: _authBloc.state.user!.uid,
        locationCountry: event.locationCountry,
      );

      emit(
        state.copyWith(posts: posts, status: FeedOOTDCountryStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDCountryStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedOOTDCountryFemaleFetchPostsOOTD(
    FeedOOTDCountryFemaleFetchPostsOOTD event,
    Emitter<FeedOOTDCountryState> emit,
  ) async {
    try {
      final posts = await _feedRepository.getFeedOOTDFemale(
        userId: _authBloc.state.user!.uid,
      );

      emit(
        state.copyWith(posts: posts, status: FeedOOTDCountryStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDCountryStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }
}
