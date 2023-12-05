import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:equatable/equatable.dart';

import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:flutter/material.dart';

part 'following_event.dart';
part 'following_state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  FollowingBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FollowingState.initial()) {
    on<FollowingFetchPosts>(_mapFollowingFetchPostsToState);
    on<FollowingPaginatePosts>(_mapFollowingPaginatePostsToState);
  }
  Future<void> _mapFollowingFetchPostsToState(
    FollowingFetchPosts event,
    Emitter<FollowingState> emit,
  ) async {
    try {
      debugPrint('Fetching posts for user: ${_authBloc.state.user!.uid}');
      final posts =
          await _postRepository.getUserFeed(userId: _authBloc.state.user!.uid);
      debugPrint('Number of posts fetched: ${posts.length}');

      _likedPostsCubit.clearAllLikedPosts();
      debugPrint('Cleared all liked posts');

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );
      debugPrint('Liked post IDs: ${likedPostIds.length}');

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
      debugPrint('Updated liked posts');

      emit(
        state.copyWith(posts: posts, status: FollowingStatus.loaded),
      );
      debugPrint('State emitted with loaded status');
    } catch (err) {
      debugPrint('Error in fetching posts: $err');
      emit(state.copyWith(
        status: FollowingStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
      debugPrint('State emitted with error status');
    }
  }

  Future<void> _mapFollowingPaginatePostsToState(
    FollowingPaginatePosts event,
    Emitter<FollowingState> emit,
  ) async {
    emit(state.copyWith(status: FollowingStatus.paginating));
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last!.id : null;

      final posts = await _postRepository.getUserFeed(
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
        state.copyWith(posts: updatedPosts, status: FollowingStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FollowingStatus.error,
        failure: const Failure(
            message: 'Quelque chose s\'est mal passé ! Veuillez réessayer.'),
      ));
    }
  }
}
