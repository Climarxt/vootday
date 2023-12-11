import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_state.dart';
part 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_event.dart';

class FeedCollectionBloc
    extends Bloc<FeedCollectionEvent, FeedCollectionState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  FeedCollectionBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(FeedCollectionState.initial()) {
    on<FeedCollectionFetchPostsCollections>(
        _mapFeedCollectionFetchPostsCollection);
    on<FeedCollectionClean>(_onFeedCollectionClean);
  }

  Future<void> _mapFeedCollectionFetchPostsCollection(
    FeedCollectionFetchPostsCollections event,
    Emitter<FeedCollectionState> emit,
  ) async {
    if (state.hasFetchedInitialPosts &&
        event.collectionId == state.collection?.id) {
      debugPrint(
          'FeedCollectionFetchPostsCollections : Already fetched initial posts for collection ${event.collectionId}.');
      return;
    }
    _onFeedCollectionClean(FeedCollectionClean(), emit);
    debugPrint(
        'FeedCollectionFetchPostsCollections : Fetching posts for collection ${event.collectionId}.');

    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            'FeedCollectionFetchPostsCollections : User ID is null. User must be logged in to fetch posts.');
      }
      debugPrint(
          'FeedCollectionFetchPostsCollections : Fetching posts for user $userId.');

      final posts = await _feedRepository.getFeedCollection(
        userId: userId,
        collectionId: event.collectionId,
      );
      debugPrint(
          'FeedCollectionFetchPostsCollections : Fetched ${posts.length} posts.');

      emit(state.copyWith(
        posts: posts,
        status: FeedCollectionStatus.loaded,
        hasFetchedInitialPosts: true,
      ));
      debugPrint(
          'FeedCollectionFetchPostsCollections : Posts loaded successfully.');
    } catch (err) {
      debugPrint(
          'FeedCollectionFetchPostsCollections : Error fetching posts - ${err.toString()}');
      emit(state.copyWith(
        status: FeedCollectionStatus.error,
        failure: Failure(
            message:
                'FeedCollectionFetchPostsCollections : Unable to load the feed - ${err.toString()}'),
      ));
    }
  }

  Future<void> _onFeedCollectionClean(
    FeedCollectionClean event,
    Emitter<FeedCollectionState> emit,
  ) async {
    emit(FeedCollectionState.initial()); // Remet l'état à son état initial
  }
}
