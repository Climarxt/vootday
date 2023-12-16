import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/profile/bloc/feed_mylikes/feed_mylikes_state.dart';
part 'package:bootdv2/screens/profile/bloc/feed_mylikes/feed_mylikes_event.dart';

class FeedMyLikesBloc extends Bloc<FeedMyLikesEvent, FeedMyLikesState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;

  FeedMyLikesBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        super(FeedMyLikesState.initial()) {
    on<FeedMyLikesFetchPosts>(_mapFeedMyLikesFetchPostsCollection);
    on<FeedMyLikesClean>(_onFeedMyLikesClean);
  }

  Future<void> _mapFeedMyLikesFetchPostsCollection(
    FeedMyLikesFetchPosts event,
    Emitter<FeedMyLikesState> emit,
  ) async {
    _onFeedMyLikesClean(FeedMyLikesClean(), emit);
    debugPrint('FeedMyLikesFetchPosts : Fetching posts for MyLikes');

    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            'FeedMyLikesFetchPosts : User ID is null. User must be logged in to fetch posts.');
      }
      debugPrint(
          'FeedMyLikesFetchPosts : Fetching posts for user $userId.');

      final posts = await _feedRepository.getFeedMyLikes(
        userId: userId,
      );
      debugPrint(
          'FeedMyLikesFetchPosts : Fetched ${posts.length} posts.');

      emit(state.copyWith(
        posts: posts,
        status: FeedMyLikesStatus.loaded,
        hasFetchedInitialPosts: true,
      ));
      debugPrint(
          'FeedMyLikesFetchPosts : Posts loaded successfully.');
    } catch (err) {
      debugPrint(
          'FeedMyLikesFetchPosts : Error fetching posts - ${err.toString()}');
      emit(state.copyWith(
        status: FeedMyLikesStatus.error,
        failure: Failure(
            message:
                'FeedMyLikesFetchPosts : Unable to load the feed - ${err.toString()}'),
      ));
    }
  }

  Future<void> _onFeedMyLikesClean(
    FeedMyLikesClean event,
    Emitter<FeedMyLikesState> emit,
  ) async {
    emit(FeedMyLikesState.initial()); // Remet l'état à son état initial
  }
}
