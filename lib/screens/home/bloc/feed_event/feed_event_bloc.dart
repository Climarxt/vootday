import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';

part 'package:bootdv2/screens/home/bloc/feed_event/feed_event_state.dart';
part 'package:bootdv2/screens/home/bloc/feed_event/feed_event_event.dart';

class FeedEventBloc extends Bloc<FeedEventEvent, FeedEventState> {
  final FeedRepository _feedRepository;
  final EventRepository _eventRepository;
  final AuthBloc _authBloc;

  FeedEventBloc({
    required FeedRepository feedRepository,
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _feedRepository = feedRepository,
        _eventRepository = eventRepository,
        _authBloc = authBloc,
        super(FeedEventState.initial()) {
    on<FeedEventFetchPostsEvents>(_mapFeedEventFetchPostsEvent);
    on<FeedEventFetchEventDetails>(_onFeedEventFetchEventDetails);
    on<FeedEventClean>(_onFeedEventClean);
  }

  Future<void> _mapFeedEventFetchPostsEvent(
    FeedEventFetchPostsEvents event,
    Emitter<FeedEventState> emit,
  ) async {
    if (state.hasFetchedInitialPosts) {
      return; // Si les données initiales sont déjà chargées, ne rien faire
    }
    debugPrint('In _mapFeedEventFetchPostsEvent with eventId: ${event.eventId}');
    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            'User ID is null. User must be logged in to fetch posts.');
      }
      debugPrint('FeedEventBloc: Fetching posts for user $userId.');

      // Retrieve the event details
      final Event? eventDetails =
          await _eventRepository.getEventById(event.eventId);
      if (eventDetails == null) {
        throw Exception("Event with id ${event.eventId} does not exist.");
      }
      debugPrint('FeedEventBloc: Retrieved event details for ${event.eventId}.');

      // Continue with fetching posts
      final posts = await _feedRepository.getFeedEvent(
        userId: userId,
        eventId: event.eventId,
      );
      debugPrint('FeedEventBloc: Fetched ${posts.length} posts.');

      // Emit the new state with the posts and event details
      emit(state.copyWith(
        posts: posts,
        status: FeedEventStatus.loaded,
        event: eventDetails, // Pass the retrieved Event object here
        hasFetchedInitialPosts: true, // Set this flag to true after fetching
      ));
      debugPrint('FeedEventBloc: Posts loaded successfully.');
    } catch (err) {
      debugPrint('FeedEventBloc: Error fetching posts - ${err.toString()}');
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
      debugPrint(
          '_onFeedEventFetchEventDetails : Fetching event details for event ID: ${event.eventId}');
      final eventDetails = await _eventRepository.getEventById(event.eventId);
      debugPrint(
          '_onFeedEventFetchEventDetails : Fetched event details: $eventDetails');
      emit(state.copyWith(
          event: eventDetails)); // Mettez à jour l'état avec l'Event
    } catch (_) {
      debugPrint('_onFeedEventFetchEventDetails : Error loading event details');
      emit(state.copyWith(
        status: FeedEventStatus.error,
        failure: const Failure(
            message:
                '_onFeedEventFetchEventDetails : Erreur de chargement des détails de l\'événement'),
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
