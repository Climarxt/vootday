import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/event/feed_event_event.dart';
part 'package:bootdv2/screens/home/bloc/event/feed_event_state.dart';


class FeedEventBloc extends Bloc<FeedEventEvent, FeedEventState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  FeedEventBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FeedEventState.initial()) {
    on<FeedEventFetchPostsMonth>(_mapFeedEventFetchPostsMonth);
    on<FeedEventFetchPosts>(_mapFeedEventFetchPostsToState);
    on<FeedEventPaginatePosts>(_mapFeedEventPaginatePostsToState);
  }

  Future<void> _mapFeedEventFetchPostsMonth(
    FeedEventFetchPostsMonth event,
    Emitter<FeedEventState> emit,
  ) async {
    try {
      final posts = await _postRepository.getFeedEvent(
          userId: _authBloc.state.user!.uid);

      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(
        state.copyWith(posts: posts, status: FeedEventStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedEventStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedEventFetchPostsToState(
    FeedEventFetchPosts event,
    Emitter<FeedEventState> emit,
  ) async {
    try {
      final posts = await _postRepository.getFeedEvent(
          userId: _authBloc.state.user!.uid);

      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user!.uid,
        posts: posts,
      );

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      emit(
        state.copyWith(posts: posts, status: FeedEventStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedEventStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedEventPaginatePostsToState(
    FeedEventPaginatePosts event,
    Emitter<FeedEventState> emit,
  ) async {
    emit(state.copyWith(status: FeedEventStatus.paginating));
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last!.id : null;

      final posts = await _postRepository.getFeedEvent(
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
        state.copyWith(posts: updatedPosts, status: FeedEventStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedEventStatus.error,
        failure: const Failure(
            message: 'Quelque chose s\'est mal passé ! Veuillez réessayer.'),
      ));
    }
  }
}
