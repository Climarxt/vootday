import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/profile/bloc/feed_mylikes/feed_mylikes_state.dart';
part 'package:bootdv2/screens/profile/bloc/feed_mylikes/feed_mylikes_event.dart';

class FeedMyLikesBloc extends Bloc<FeedMyLikesEvent, FeedMyLikesState> {
  final FeedRepository _feedRepository;
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final ContextualLogger logger;

  FeedMyLikesBloc({
    required FeedRepository feedRepository,
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _authBloc = authBloc,
        _postRepository = postRepository,
        logger = ContextualLogger('FeedMyLikesBloc'),
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
    logger.logInfo('_mapFeedMyLikesFetchPosts',
        'Fetching posts for MyLikes', {'event': event});

    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            'User ID is null. User must be logged in to fetch posts.');
      }
      logger.logInfo('_mapFeedMyLikesFetchPosts',
          'Fetching posts for user', {'userId': userId});

      final posts = await _feedRepository.getFeedMyLikes(userId: userId);
      logger.logInfo('_mapFeedMyLikesFetchPosts',
          'Fetched posts', {'postCount': posts.length});

      emit(state.copyWith(
        posts: posts,
        status: FeedMyLikesStatus.loaded,
        hasFetchedInitialPosts: true,
        isPostInLikes: true,
      ));
      logger.logInfo('_mapFeedMyLikesFetchPosts',
          'Posts loaded successfully');
    } catch (err) {
      logger.logError('_mapFeedMyLikesFetchPosts',
          'Error fetching posts', {'error': err.toString()});
      emit(state.copyWith(
        status: FeedMyLikesStatus.error,
        failure:
            Failure(message: 'Unable to load the feed - ${err.toString()}'),
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
      logger.logInfo(
          '_onCheckPostInLikes',
          'Checking if post is in likes',
          {'userId': userId, 'postId': event.postId});
      if (userId == null) {
        throw Exception(
            'User ID is null. User must be logged in to fetch posts.');
      }
      final isPostInLikes = await _postRepository.isPostInLikes(
          postId: event.postId, userId: userId);
      logger.logInfo(
          '_onCheckPostInLikes',
          'Checked post in likes',
          {'postId': event.postId, 'isPostInLikes': isPostInLikes});

      emit(state.copyWith(
        isPostInLikes: isPostInLikes,
      ));
    } catch (e) {
      logger.logError('_onCheckPostInLikes',
          'Error checking post in collection', {'error': e.toString()});
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
            'User ID is null. User must be logged in to fetch posts.');
      }
      await _postRepository.deletePostRefFromLikes(
          postId: event.postId, userId: userId);
      logger.logInfo(
          '_onDeletePostRefFromLikes',
          'Post reference deleted from likes',
          {'postId': event.postId, 'userId': userId});
    } catch (e) {
      logger.logError('_onDeletePostRefFromLikes',
          'Error deleting post reference from likes', {'error': e.toString()});
    }
  }
}
