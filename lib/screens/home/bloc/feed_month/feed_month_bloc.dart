import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/feed_month/feed_month_state.dart';
part 'package:bootdv2/screens/home/bloc/feed_month/feed_month_event.dart';

class FeedMonthBloc extends Bloc<FeedMonthEvent, FeedMonthState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  FeedMonthBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FeedMonthState.initial()) {
    on<FeedMonthFetchPostsMonth>(_mapFeedMonthFetchPostsMonth);
    on<FeedMonthFetchPosts>(_mapFeedMonthFetchPostsToState);
    on<FeedMonthPaginatePosts>(_mapFeedMonthPaginatePostsToState);
  }

  Future<void> _mapFeedMonthFetchPostsMonth(
    FeedMonthFetchPostsMonth event,
    Emitter<FeedMonthState> emit,
  ) async {
    debugPrint('_mapFeedMonthFetchPostsMonth : Début de _mapFeedMonthFetchPostsMonth');
    try {
      final userId = _authBloc.state.user!.uid;
      debugPrint('_mapFeedMonthFetchPostsMonth : Récupération des posts pour l\'utilisateur : $userId');

      final posts = await _postRepository.getFeedMonth(userId: userId);
      debugPrint('_mapFeedMonthFetchPostsMonth : Posts récupérés : ${posts.length}');

      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: userId,
        posts: posts,
      );
      debugPrint('_mapFeedMonthFetchPostsMonth : IDs des posts aimés récupérés : ${likedPostIds.length}');

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(
        state.copyWith(posts: posts, status: FeedMonthStatus.loaded),
      );
      debugPrint('_mapFeedMonthFetchPostsMonth : État mis à jour avec les nouveaux posts');
    } catch (err) {
      debugPrint('_mapFeedMonthFetchPostsMonth : Erreur lors de la récupération des posts : $err');
      emit(state.copyWith(
        status: FeedMonthStatus.error,
        failure:
            const Failure(message: '_mapFeedMonthFetchPostsMonth : Nous n\'avons pas pu charger votre flux'),
      ));
    }
    debugPrint('_mapFeedMonthFetchPostsMonth : Fin de _mapFeedMonthFetchPostsMonth');
  }

  Future<void> _mapFeedMonthFetchPostsToState(
    FeedMonthFetchPosts event,
    Emitter<FeedMonthState> emit,
  ) async {
    try {
      final posts =
          await _postRepository.getFeedMonth(userId: _authBloc.state.user!.uid);

      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(
        state.copyWith(posts: posts, status: FeedMonthStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedMonthStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedMonthPaginatePostsToState(
    FeedMonthPaginatePosts event,
    Emitter<FeedMonthState> emit,
  ) async {
    emit(state.copyWith(status: FeedMonthStatus.paginating));
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last!.id : null;

      final posts = await _postRepository.getFeedMonth(
        userId: _authBloc.state.user!.uid,
        lastPostId: lastPostId,
      );
      final updatedPosts = List<Post?>.from(state.posts)..addAll(posts);

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(
        state.copyWith(posts: updatedPosts, status: FeedMonthStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedMonthStatus.error,
        failure: const Failure(
            message: 'Quelque chose s\'est mal passé ! Veuillez réessayer.'),
      ));
    }
  }
}