import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
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
    on<FeedEventFetchPostsEvents>(_mapFeedEventFetchPostsEvent);
    on<FeedEventPaginatePostsEvents>(_mapFeedEventPaginatePostsEventsToState);
    on<FeedEventFetchEventDetails>(_onFeedEventFetchEventDetails);
    on<FeedEventClean>(_onFeedEventClean);
  }

  Future<void> _mapFeedEventFetchPostsEvent(
    FeedEventFetchPostsEvents event,
    Emitter<FeedEventState> emit,
  ) async {
    if (state.hasFetchedInitialPosts && event.eventId == state.event?.id) {
      print(
          'FeedEventBloc: Already fetched initial posts for event ${event.eventId}.');
      return;
    }
    _onFeedEventClean(FeedEventClean(), emit);
    print('FeedEventBloc: Fetching posts for event ${event.eventId}.');

    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            'User ID is null. User must be logged in to fetch posts.');
      }
      print('FeedEventBloc: Fetching posts for user $userId.');

      // Retrieve the event details
      final Event? eventDetails =
          await _postRepository.getEventById(event.eventId);
      if (eventDetails == null) {
        throw Exception("Event with id ${event.eventId} does not exist.");
      }
      print('FeedEventBloc: Retrieved event details for ${event.eventId}.');

      // Continue with fetching posts
      final posts = await _postRepository.getFeedEvent(
        userId: userId,
        eventId: event.eventId,
      );
      print('FeedEventBloc: Fetched ${posts.length} posts.');

      _likedPostsCubit.clearAllLikedPosts();
      print('FeedEventBloc: Cleared liked posts.');

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: userId,
        posts: posts,
      );
      print('FeedEventBloc: Fetched liked post IDs.');

      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
      print('FeedEventBloc: Updated liked posts.');

      // Emit the new state with the posts and event details
      emit(state.copyWith(
        posts: posts,
        status: FeedEventStatus.loaded,
        event: eventDetails, // Pass the retrieved Event object here
        hasFetchedInitialPosts: true, // Set this flag to true after fetching
      ));
      print('FeedEventBloc: Posts loaded successfully.');
    } catch (err) {
      print('FeedEventBloc: Error fetching posts - ${err.toString()}');
      emit(state.copyWith(
        status: FeedEventStatus.error,
        failure: Failure(
            message:
                '_mapFeedEventFetchPostsEvent : Unable to load the feed - ${err.toString()}'),
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

  Future<void> _mapFeedEventPaginatePostsEventsToState(
    FeedEventPaginatePostsEvents event,
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
