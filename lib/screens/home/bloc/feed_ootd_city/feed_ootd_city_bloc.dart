// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
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
  final ContextualLogger logger;

  FeedOOTDCityBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        logger = ContextualLogger('FeedOOTDCityBloc'),
        super(FeedOOTDCityState.initial()) {
    on<FeedOOTDCityManFetchPostsByCity>(_mapFeedOOTDCityManFetchPostsByCity);
    on<FeedOOTDCityManFetchMorePosts>(_mapFeedOOTDCityManFetchMorePosts);
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

      logger.logInfo('FeedOOTDCityBloc', 'Posts loaded', {
        'posts': posts.map((post) => post.id).toList(),
      });

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

  Future<void> _mapFeedOOTDCityManFetchMorePosts(
    FeedOOTDCityManFetchMorePosts event,
    Emitter<FeedOOTDCityState> emit,
  ) async {
    if (state.status == FeedOOTDCityStatus.paginating) return;
    try {
      emit(state.copyWith(status: FeedOOTDCityStatus.paginating));

      // Utiliser l'ID du dernier document dans la collection `posts`
      final lastPostDocId =
          state.posts.isNotEmpty ? state.posts.last!.id : null;

      logger.logInfo('FeedOOTDCityBloc', 'Last post document ID', {
        'lastPostDocId': lastPostDocId,
      });

      final newPosts = await _feedRepository.getFeedOOTDManCity(
        userId: _authBloc.state.user!.uid,
        locationCountry: event.locationCountry,
        locationState: event.locationState,
        locationCity: event.locationCity,
        lastPostId: lastPostDocId,
      );

      logger.logInfo('FeedOOTDCityBloc', 'More posts loaded', {
        'newPosts': newPosts.map((post) => post.id).toList(),
      });

      if (newPosts.isEmpty) {
        logger.logInfo('FeedOOTDCityBloc', 'No more posts to load');
      }

      emit(state.copyWith(
        posts: [...state.posts, ...newPosts],
        status: FeedOOTDCityStatus.loaded,
      ));
      logger.logInfo('FeedOOTDCityBloc', 'Updated state with new posts');
    } catch (err) {
      logger.logError('FeedOOTDCityBloc', 'Error fetching more posts', {
        'error': err.toString(),
      });

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

      logger.logInfo('FeedOOTDCityBloc', 'Female posts loaded', {
        'posts': posts.map((post) => post?.id).toList(),
      });

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
