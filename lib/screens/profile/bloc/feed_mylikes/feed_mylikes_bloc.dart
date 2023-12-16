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
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  FeedMyLikesBloc({
    required FeedRepository feedRepository,
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        _postRepository = postRepository,
        super(FeedMyLikesState.initial()) {
    on<FeedMyLikesFetchPosts>(_mapFeedMyLikesFetchPosts);
    on<FeedMyLikesClean>(_onFeedMyLikesClean);
    on<FeedMyLikesCheckPostInLikes>(_onCheckPostInLikes);
    on<FeedMyLikesDeletePostRef>(_onDeletePostRefFromLikes);
  }

  Future<void> _mapFeedMyLikesFetchPosts(
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
      debugPrint('FeedMyLikesFetchPosts : Fetching posts for user $userId.');

      final posts = await _feedRepository.getFeedMyLikes(
        userId: userId,
      );
      debugPrint('FeedMyLikesFetchPosts : Fetched ${posts.length} posts.');

      emit(state.copyWith(
        posts: posts,
        status: FeedMyLikesStatus.loaded,
        hasFetchedInitialPosts: true,
        isPostInLikes: true,
      ));
      debugPrint('FeedMyLikesFetchPosts : Posts loaded successfully.');
    } catch (err) {
      debugPrint(
          'FeedMyLikesFetchPosts : Error fetching posts - ${err.toString()}');
      emit(state.copyWith(
        status: FeedMyLikesStatus.error,
        failure: Failure(
            message:
                'FeedMyLikesFetchPosts : Unable to load the feed - ${err.toString()}'),
        isPostInLikes: true,
      ));
    }
  }

  Future<void> _onFeedMyLikesClean(
    FeedMyLikesClean event,
    Emitter<FeedMyLikesState> emit,
  ) async {
    emit(FeedMyLikesState.initial()); // Remet l'état à son état initial
  }

  Future<void> _onCheckPostInLikes(
    FeedMyLikesCheckPostInLikes event,
    Emitter<FeedMyLikesState> emit,
  ) async {
    try {
      final userId = _authBloc.state.user?.uid;
      debugPrint('_onCheckPostInLikes : User ID - $userId');
      if (userId == null) {
        throw Exception(
            '_onCheckPostInLikes : User ID is null. User must be logged in to fetch posts.');
      }
      final isPostInLikes = await _postRepository.isPostInLikes(
        postId: event.postId,
        userId: userId,
      );
      debugPrint(
          '_onCheckPostInLikes : Post ${event.postId} is in likes - $isPostInLikes');

      emit(state.copyWith(
        isPostInLikes: isPostInLikes,
      ));
    } catch (e) {
      debugPrint(
          '_onCheckPostInLikes : Error checking post in collection: ${e.toString()}');
    }
  }

  Future<void> _onDeletePostRefFromLikes(
    FeedMyLikesDeletePostRef event,
    Emitter<FeedMyLikesState> emit,
  ) async {
    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            '_onDeletePostRefFromCollection : User ID is null. User must be logged in to fetch posts.');
      }
      await _postRepository.deletePostRefFromLikes(
          postId: event.postId, userId: userId);

      debugPrint(
          '_onDeletePostRefFromCollection : Post référence supprimée de la collection avec succès.');
    } catch (e) {
      debugPrint(
          '_onDeletePostRefFromCollection : Erreur lors de la suppression de la post référence de la collection: ${e.toString()}');
    }
  }
}
