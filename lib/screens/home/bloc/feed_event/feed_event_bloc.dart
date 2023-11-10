import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/models/event_model.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/feed_event/feed_event_state.dart';
part 'package:bootdv2/screens/home/bloc/feed_event/feed_event_event.dart';

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
    on<FeedEventFetchPostsEvent>(_mapFeedEventFetchPostsEvent);
    on<FeedEventPaginatePosts>(_mapFeedEventPaginatePostsToState);
    on<FeedEventFetchEventDetails>(_onFeedEventFetchEventDetails);
    on<FeedEventClean>(_onFeedEventClean);
  }

  Future<void> _mapFeedEventFetchPostsEvent(
    FeedEventFetchPostsEvent event,
    Emitter<FeedEventState> emit,
  ) async {
    emit(FeedEventState.initial());
    try {
      final posts = await _postRepository.getFeedEvent(
        userId: _authBloc.state.user!.uid,
        eventId: event.eventId,
      );

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
        failure: const Failure(
            message:
                '_mapFeedEventFetchPostsEvent : Nous n\'avons pas pu charger votre flux'),
      ));
    }
  }

  Future<void> _onFeedEventFetchEventDetails(
    FeedEventFetchEventDetails event,
    Emitter<FeedEventState> emit,
  ) async {
    try {
      print(
          '_onFeedEventFetchEventDetails : Fetching event details for event ID: ${event.eventId}');
      final eventDetails = await _postRepository.getEventById(event.eventId);
      print(
          '_onFeedEventFetchEventDetails : Fetched event details: $eventDetails');
      emit(state.copyWith(
          event: eventDetails)); // Mettez à jour l'état avec l'Event
    } catch (_) {
      print('_onFeedEventFetchEventDetails : Error loading event details');
      emit(state.copyWith(
        status: FeedEventStatus.error,
        failure: Failure(
            message:
                '_onFeedEventFetchEventDetails : Erreur de chargement des détails de l\'événement'),
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
        eventId: event.eventId,
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

  Future<void> _onFeedEventClean(
    FeedEventClean event,
    Emitter<FeedEventState> emit,
  ) async {
    emit(FeedEventState.initial()); // Remet l'état à son état initial
  }
}
