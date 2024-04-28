import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/models/comment_event_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'comments_event_event.dart';
part 'comments_event_state.dart';

class CommentsEventBloc extends Bloc<CommentsEvent, CommentsEventState> {
  final EventRepository _eventRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Comment?>>>? _commentsSubscription;

  CommentsEventBloc({
    required EventRepository eventRepository,
    required AuthBloc authBloc,
  })  : _eventRepository = eventRepository,
        _authBloc = authBloc,
        super(CommentsEventState.initial()) {
    on<CommentsEventFetchComments>(_mapCommentsEventFetchCommentsToState);
    on<CommentsUpdateComments>(_mapCommentsUpdateCommentsToState);
    on<CommentsPostComment>(_mapCommentsPostCommentToState);
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }

  Future<void> _mapCommentsEventFetchCommentsToState(
    CommentsEventFetchComments event,
    Emitter<CommentsEventState> emit,
  ) async {
    emit(state.copyWith(status: CommentsEventStatus.loading));

    try {
      _commentsSubscription?.cancel();
      final eventPost = await _eventRepository.getEventById(event.eventId);

      if (eventPost == null) {
        // Gérer le cas où le post n'existe pas
        emit(state.copyWith(
          status: CommentsEventStatus.error,
          failure: const Failure(message: 'L\'event demandé n\'existe pas'),
        ));
        return;
      }

      _commentsSubscription = _eventRepository
          .getEventComments(eventId: event.eventId)
          .listen((comments) async {
        final allComments = await Future.wait(comments);
        add(CommentsUpdateComments(comments: allComments));
      });

      emit(state.copyWith(event: eventPost, status: CommentsEventStatus.loaded));
    } catch (err) {
      emit(state.copyWith(
        status: CommentsEventStatus.error,
        failure: const Failure(
            message: 'Nous n\'avons pas pu charger les commentaires'),
      ));
    }
  }

  Future<void> _mapCommentsUpdateCommentsToState(
    CommentsUpdateComments event,
    Emitter<CommentsEventState> emit,
  ) async {
    emit(state.copyWith(comments: event.comments));
  }

  Future<void> _mapCommentsPostCommentToState(
    CommentsPostComment event,
    Emitter<CommentsEventState> emit,
  ) async {
    debugPrint('_mapCommentsPostCommentToState : Début de _mapCommentsPostCommentToState');

    if (state.event == null) {
      debugPrint('_mapCommentsPostCommentToState : Post is null');
      emit(state.copyWith(
        status: CommentsEventStatus.error,
        failure: const Failure(message: '_mapCommentsPostCommentToState :Le event est introuvable'),
      ));
      return;
    }

    emit(state.copyWith(status: CommentsEventStatus.submitting));
    debugPrint('_mapCommentsPostCommentToState :État de soumission émis');

    try {
      final post = await _eventRepository.getEventById(event.eventId);
      if (post == null) {
        throw Exception('_mapCommentsPostCommentToState :Post récupéré est null');
      }

      final author = User.empty.copyWith(id: _authBloc.state.user!.uid);
      final comment = CommentEvent(
        eventId: post.id,
        author: author,
        content: event.content,
        date: DateTime.now(),
      );

      await _eventRepository.createComment(comment: comment);

      emit(state.copyWith(status: CommentsEventStatus.loaded));
      debugPrint('_mapCommentsPostCommentToState : État de chargement émis');
    } catch (err) {
      debugPrint('_mapCommentsPostCommentToState : Erreur capturée: $err');
      emit(state.copyWith(
        status: CommentsEventStatus.error,
        failure: const Failure(message: '_mapCommentsPostCommentToState : Comment failed to post'),
      ));
      debugPrint('_mapCommentsPostCommentToState : État d\'erreur émis');
    }

    debugPrint('_mapCommentsPostCommentToState : Fin de _mapCommentsPostCommentToState');
  }
}
