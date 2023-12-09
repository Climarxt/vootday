import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_state.dart';
part 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_event.dart';

class FeedCollectionBloc
    extends Bloc<FeedCollectionEvent, FeedCollectionState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  FeedCollectionBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FeedCollectionState.initial()) {
    on<FeedCollectionFetchPostsCollections>(
        _mapFeedCollectionFetchPostsCollection);
    on<FeedCollectionPaginatePostsCollections>(
        _mapFeedCollectionPaginatePostsCollectionsToState);
    on<FeedCollectionClean>(_onFeedCollectionClean);
  }

  Future<void> _mapFeedCollectionFetchPostsCollection(
    FeedCollectionFetchPostsCollections event,
    Emitter<FeedCollectionState> emit,
  ) async {
    if (state.hasFetchedInitialPosts &&
        event.collectionId == state.collection?.id) {
      debugPrint(
          '_mapFeedCollectionFetchPostsCollection : Already fetched initial posts for collection ${event.collectionId}.');
      return;
    }
    _onFeedCollectionClean(FeedCollectionClean(), emit);
    debugPrint(
        '_mapFeedCollectionFetchPostsCollection : Fetching posts for collection ${event.collectionId}.');

    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            'User ID is null. User must be logged in to fetch posts.');
      }
      debugPrint(
          '_mapFeedCollectionFetchPostsCollection : Fetching posts for user $userId.');

      // Continue with fetching posts
      final posts = await _postRepository.getFeedCollection(
        userId: userId,
        collectionId: event.collectionId,
      );
      debugPrint(
          '_mapFeedCollectionFetchPostsCollection : Fetched ${posts.length} posts.');

      _likedPostsCubit.clearAllLikedPosts();
      debugPrint(
          '_mapFeedCollectionFetchPostsCollection : Cleared liked posts.');

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: userId,
        posts: posts,
      );
      debugPrint(
          '_mapFeedCollectionFetchPostsCollection : Fetched liked post IDs.');

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
      debugPrint(
          '_mapFeedCollectionFetchPostsCollection : Updated liked posts.');

      emit(state.copyWith(
        posts: posts,
        status: FeedCollectionStatus.loaded,
        hasFetchedInitialPosts: true,
      ));
      debugPrint(
          '_mapFeedCollectionFetchPostsCollection : Posts loaded successfully.');
    } catch (err) {
      debugPrint(
          '_mapFeedCollectionFetchPostsCollection : Error fetching posts - ${err.toString()}');
      emit(state.copyWith(
        status: FeedCollectionStatus.error,
        failure: Failure(
            message:
                '_mapFeedCollectionFetchPostsCollection : Unable to load the feed - ${err.toString()}'),
      ));
    }
  }

  Future<void> _mapFeedCollectionPaginatePostsCollectionsToState(
    FeedCollectionPaginatePostsCollections event,
    Emitter<FeedCollectionState> emit,
  ) async {
    emit(state.copyWith(status: FeedCollectionStatus.paginating));
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last!.id : null;

      final posts = await _postRepository.getFeedCollection(
        userId: _authBloc.state.user!.uid,
        lastPostId: lastPostId,
        collectionId: event.collectionId,
      );
      final updatedPosts = List<Post?>.from(state.posts)..addAll(posts);

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(
        state.copyWith(
            posts: updatedPosts, status: FeedCollectionStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedCollectionStatus.error,
        failure: const Failure(
            message: 'Quelque chose s\'est mal passé ! Veuillez réessayer.'),
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
