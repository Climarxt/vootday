import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_state.dart';
part 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_event.dart';

class FeedCollectionBloc
    extends Bloc<FeedCollectionEvent, FeedCollectionState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;
  final ContextualLogger logger;

  FeedCollectionBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        logger = ContextualLogger('FeedCollectionBloc'),
        super(FeedCollectionState.initial()) {
    on<FeedCollectionFetchPostsCollections>(
        _mapFeedCollectionFetchPostsCollection);
    on<FeedCollectionClean>(_onFeedCollectionClean);
  }

  Future<void> _mapFeedCollectionFetchPostsCollection(
    FeedCollectionFetchPostsCollections event,
    Emitter<FeedCollectionState> emit,
  ) async {
    const String functionName = '_mapFeedCollectionFetchPostsCollection';
    if (state.hasFetchedInitialPosts &&
        event.collectionId == state.collection?.id) {
      logger.logInfo(
          functionName, 'Already fetched initial posts for collection.', {
        'collectionId': event.collectionId,
      });
      return;
    }
    // _onFeedCollectionClean(FeedCollectionClean(), emit);
    logger.logInfo(functionName, 'Fetching posts for collection.', {
      'collectionId': event.collectionId,
    });

    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            'User ID is null. User must be logged in to fetch posts.');
      }
      logger.logInfo(functionName, 'Fetching posts for user.', {
        'userId': userId,
      });

      final posts = await _feedRepository.getFeedCollection(
        userId: userId,
        collectionId: event.collectionId,
      );
      logger.logInfo(functionName, 'Fetched posts.', {
        'postsCount': posts.length,
      });

      emit(state.copyWith(
        posts: posts,
        status: FeedCollectionStatus.loaded,
        hasFetchedInitialPosts: true,
      ));
      logger.logInfo(functionName, 'Posts loaded successfully.');
    } catch (err) {
      logger.logError(functionName, 'Error fetching posts.', {
        'error': err.toString(),
      });
      emit(state.copyWith(
        status: FeedCollectionStatus.error,
        failure: Failure(
          message: 'Unable to load the feed - ${err.toString()}',
        ),
      ));
    }
  }

  Future<void> _onFeedCollectionClean(
    FeedCollectionClean event,
    Emitter<FeedCollectionState> emit,
  ) async {
    emit(FeedCollectionState.initial());
    logger.logInfo('_onFeedCollectionClean', 'State reset to initial.');
  }
}
