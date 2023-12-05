import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';

part 'following_event.dart';
part 'following_state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  FollowingBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(FollowingState.initial()) {
    on<FollowingFetchPosts>(_mapFollowingFetchPostsToState);
    on<FollowingPaginatePosts>(_mapFollowingPaginatePostsToState);
  }

  Future<void> _mapFollowingFetchPostsToState(
    FollowingFetchPosts event,
    Emitter<FollowingState> emit,
  ) async {
    try {
      final posts =
          await _postRepository.getUserFeed(userId: _authBloc.state.user!.uid);
      emit(
        state.copyWith(posts: posts, status: FollowingStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FollowingStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
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
