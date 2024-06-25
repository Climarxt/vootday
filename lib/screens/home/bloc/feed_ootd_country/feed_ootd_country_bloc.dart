// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
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
  final ContextualLogger logger;

  FeedOOTDCountryBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        logger = ContextualLogger('FeedOOTDCountryBloc'),
        super(FeedOOTDCountryState.initial()) {
    on<FeedOOTDCountryManFetchPostsByCountry>(
        _mapFeedOOTDCountryManFetchPostsByCountry);
    on<FeedOOTDCountryManFetchMorePosts>(_mapFeedOOTDCountryManFetchMorePosts);
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

      logger.logInfo('FeedOOTDCountryBloc', 'Posts loaded', {
        'posts': posts.map((post) => post?.id).toList(),
      });

      emit(
        state.copyWith(posts: posts, status: FeedOOTDCountryStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedOOTDCountryStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedOOTDCountryManFetchMorePosts(
    FeedOOTDCountryManFetchMorePosts event,
    Emitter<FeedOOTDCountryState> emit,
  ) async {
    if (state.status == FeedOOTDCountryStatus.paginating) return;
    try {
      emit(state.copyWith(status: FeedOOTDCountryStatus.paginating));

      final lastPostDocId =
          state.posts.isNotEmpty ? state.posts.last?.id : null;

      logger.logInfo('FeedOOTDCountryBloc', 'Last post document ID', {
        'lastPostDocId': lastPostDocId,
      });

      final newPosts = await _feedRepository.getFeedOOTDManCountry(
        userId: _authBloc.state.user!.uid,
        locationCountry: event.locationCountry,
        lastPostId: lastPostDocId,
      );

      logger.logInfo('FeedOOTDCountryBloc', 'More posts loaded', {
        'newPosts': newPosts.map((post) => post?.id).toList(),
      });

      if (newPosts.isEmpty) {
        logger.logInfo('FeedOOTDCountryBloc', 'No more posts to load');
      }

      emit(state.copyWith(
        posts: [...state.posts, ...newPosts.whereType<Post>()],
        status: FeedOOTDCountryStatus.loaded,
      ));
    } catch (err) {
      logger.logError('FeedOOTDCountryBloc', 'Error fetching more posts', {
        'error': err.toString(),
      });

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

      logger.logInfo('FeedOOTDCountryBloc', 'Female posts loaded', {
        'posts': posts.map((post) => post?.id).toList(),
      });

      emit(
        state.copyWith(posts: posts, status: FeedOOTDCountryStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedOOTDCountryStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }
}
