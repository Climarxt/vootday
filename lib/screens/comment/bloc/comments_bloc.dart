import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Comment?>>>? _commentsSubscription;

  CommentsBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(CommentsState.initial()) {
    on<CommentsFetchComments>(_mapCommentsFetchCommentsToState);
    on<CommentsUpdateComments>(_mapCommentsUpdateCommentsToState);
    on<CommentsPostComment>(_mapCommentsPostCommentToState);
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }

  Future<void> _mapCommentsFetchCommentsToState(
    CommentsFetchComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(status: CommentsStatus.loading));

    try {
      _commentsSubscription?.cancel();
      final post = await _postRepository.getPostById(event.postId);

      if (post == null) {
        // Gérer le cas où le post n'existe pas
        emit(state.copyWith(
          status: CommentsStatus.error,
          failure: const Failure(message: 'Le post demandé n\'existe pas'),
        ));
        return;
      }

      _commentsSubscription = _postRepository
          .getPostComments(postId: event.postId)
          .listen((comments) async {
        final allComments = await Future.wait(comments);
        add(CommentsUpdateComments(comments: allComments));
      });

      emit(state.copyWith(post: post, status: CommentsStatus.loaded));
    } catch (err) {
      emit(state.copyWith(
        status: CommentsStatus.error,
        failure: const Failure(
            message: 'Nous n\'avons pas pu charger les commentaires'),
      ));
    }
  }

  Future<void> _mapCommentsUpdateCommentsToState(
    CommentsUpdateComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(comments: event.comments));
  }

  Future<void> _mapCommentsPostCommentToState(
    CommentsPostComment event,
    Emitter<CommentsState> emit,
  ) async {
    debugPrint('Début de _mapCommentsPostCommentToState');

    if (state.post == null) {
      debugPrint('Post is null');
      emit(state.copyWith(
        status: CommentsStatus.error,
        failure: const Failure(message: 'Le post est introuvable'),
      ));
      return;
    }

    emit(state.copyWith(status: CommentsStatus.submitting));
    debugPrint('État de soumission émis');

    try {
      final post = await _postRepository.getPostById(event.postId);
      if (post == null) {
        throw Exception('Post récupéré est null');
      }

      final author = User.empty.copyWith(id: _authBloc.state.user!.uid);
      final comment = Comment(
        postId: post.id!,
        author: author,
        content: event.content,
        date: DateTime.now(),
      );

      await _postRepository.createComment(post: post, comment: comment);

      emit(state.copyWith(status: CommentsStatus.loaded));
      debugPrint('État de chargement émis');
    } catch (err) {
      debugPrint('Erreur capturée: $err');
      emit(state.copyWith(
        status: CommentsStatus.error,
        failure: const Failure(message: 'Comment failed to post'),
      ));
      debugPrint('État d\'erreur émis');
    }

    debugPrint('Fin de _mapCommentsPostCommentToState');
  }
}
