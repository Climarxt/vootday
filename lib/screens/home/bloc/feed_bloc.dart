import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  FeedBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FeedState.initial()) {
    on<FeedFetchPostsOOTD>(_mapFeedFetchPostsOOTD);
    on<FeedFetchPostsMonth>(_mapFeedFetchPostsMonth);
    on<FeedFetchPosts>(_mapFeedFetchPostsToState);
    on<FeedPaginatePosts>(_mapFeedPaginatePostsToState);
  }

  Future<void> _mapFeedFetchPostsOOTD(
    FeedFetchPostsOOTD event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final posts =
          await _postRepository.getFeedOOTD(userId: _authBloc.state.user!.uid);

      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(
        state.copyWith(posts: posts, status: FeedStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

    Future<void> _mapFeedFetchPostsMonth(
    FeedFetchPostsMonth event,
    Emitter<FeedState> emit,
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
        state.copyWith(posts: posts, status: FeedStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedFetchPostsToState(
    FeedFetchPosts event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final posts =
          await _postRepository.getUserFeed(userId: _authBloc.state.user!.uid);

      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(
        state.copyWith(posts: posts, status: FeedStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedPaginatePostsToState(
    FeedPaginatePosts event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.paginating));
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
        state.copyWith(posts: updatedPosts, status: FeedStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedStatus.error,
        failure: const Failure(
            message: 'Quelque chose s\'est mal passé ! Veuillez réessayer.'),
      ));
    }
  }
}
