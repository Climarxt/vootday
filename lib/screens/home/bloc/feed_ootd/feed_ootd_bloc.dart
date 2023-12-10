// ignore_for_file: avoid_print

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_event.dart';
part 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_state.dart';

class FeedOOTDBloc extends Bloc<FeedOOTDEvent, FeedOOTDState> {
  final FeedRepository _feedRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  FeedOOTDBloc({
    required FeedRepository feedRepository,
    required AuthBloc authBloc,
    required LikedPostsCubit likedPostsCubit,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FeedOOTDState.initial()) {
    on<FeedOOTDFetchPostsOOTD>(_mapFeedOOTDFetchPostsOOTD);
    on<FeedOOTDFetchPosts>(_mapFeedOOTDFetchPostsToState);
    on<FeedOOTDPaginatePosts>(_mapFeedOOTDPaginatePostsToState);
  }

  Future<void> _mapFeedOOTDFetchPostsOOTD(
    FeedOOTDFetchPostsOOTD event,
    Emitter<FeedOOTDState> emit,
  ) async {
    try {
      final posts =
          await _feedRepository.getFeedOOTD(userId: _authBloc.state.user!.uid);

      emit(
        state.copyWith(posts: posts, status: FeedOOTDStatus.loaded),
      );
    } catch (err) {
      print(err);
      emit(state.copyWith(
        status: FeedOOTDStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedOOTDFetchPostsToState(
    FeedOOTDFetchPosts event,
    Emitter<FeedOOTDState> emit,
  ) async {
    try {
      final posts =
          await _feedRepository.getFeedOOTD(userId: _authBloc.state.user!.uid);

      emit(
        state.copyWith(posts: posts, status: FeedOOTDStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedOOTDStatus.error,
        failure:
            const Failure(message: 'Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _mapFeedOOTDPaginatePostsToState(
    FeedOOTDPaginatePosts event,
    Emitter<FeedOOTDState> emit,
  ) async {
    emit(state.copyWith(status: FeedOOTDStatus.paginating));
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last!.id : null;

      final posts = await _feedRepository.getFeedOOTD(
        userId: _authBloc.state.user!.uid,
        lastPostId: lastPostId,
      );
      final updatedPosts = List<Post?>.from(state.posts)..addAll(posts);
      
      emit(
        state.copyWith(posts: updatedPosts, status: FeedOOTDStatus.loaded),
      );
    } catch (err) {
      emit(state.copyWith(
        status: FeedOOTDStatus.error,
        failure: const Failure(
            message: 'Quelque chose s\'est mal passé ! Veuillez réessayer.'),
      ));
    }
  }
}
