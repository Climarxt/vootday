// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
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
  final ContextualLogger logger;

  FeedOOTDStateBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        logger = ContextualLogger('FeedOOTDStateBloc'),
        super(FeedOOTDStateState.initial()) {
    on<FeedOOTDStateManFetchPostsByState>(
        _mapFeedOOTDStateManFetchPostsByState);
    on<FeedOOTDStateManFetchMorePosts>(_mapFeedOOTDStateManFetchMorePosts);
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

      logger.logInfo('FeedOOTDStateBloc', 'Posts loaded', {
        'posts': posts.map((post) => post?.id).toList(),
      });

      emit(
        state.copyWith(posts: posts, status: FeedOOTDStateStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedOOTDStateStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedOOTDStateManFetchMorePosts(
    FeedOOTDStateManFetchMorePosts event,
    Emitter<FeedOOTDStateState> emit,
  ) async {
    if (state.status == FeedOOTDStateStatus.paginating) return;
    try {
      emit(state.copyWith(status: FeedOOTDStateStatus.paginating));

      final lastPostDocId =
          state.posts.isNotEmpty ? state.posts.last?.id : null;

      logger.logInfo('FeedOOTDStateBloc', 'Last post document ID', {
        'lastPostDocId': lastPostDocId,
      });

      final newPosts = await _feedRepository.getFeedOOTDManState(
        userId: _authBloc.state.user!.uid,
        locationCountry: event.locationCountry,
        locationState: event.locationState,
        lastPostId: lastPostDocId,
      );

      logger.logInfo('FeedOOTDStateBloc', 'More posts loaded', {
        'newPosts': newPosts.map((post) => post?.id).toList(),
      });

      if (newPosts.isEmpty) {
        logger.logInfo('FeedOOTDStateBloc', 'No more posts to load');
      }

      emit(state.copyWith(
        posts: [...state.posts, ...newPosts.whereType<Post>()],
        status: FeedOOTDStateStatus.loaded,
      ));
    } catch (err) {
      logger.logError('FeedOOTDStateBloc', 'Error fetching more posts', {
        'error': err.toString(),
      });

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

      logger.logInfo('FeedOOTDStateBloc', 'Female posts loaded', {
        'posts': posts.map((post) => post?.id).toList(),
      });

      emit(
        state.copyWith(posts: posts, status: FeedOOTDStateStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedOOTDStateStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }
}
