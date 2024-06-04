import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'package:bootdv2/screens/profile/bloc/mycollection/mycollection_state.dart';
part 'package:bootdv2/screens/profile/bloc/mycollection/mycollection_event.dart';

class MyCollectionBloc extends Bloc<MyCollectionEvent, MyCollectionState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final ContextualLogger logger;

  MyCollectionBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        logger = ContextualLogger('MyCollectionBloc'),
        super(MyCollectionState.initial()) {
    on<MyCollectionFetchCollections>(_mapMyCollectionFetchCollections);
    on<MyCollectionClean>(_onMyCollectionClean);
    on<MyCollectionCheckPostInCollection>(_onCheckPostInCollection);
    on<MyCollectionDeletePostRef>(_onDeletePostRefFromCollection);
  }

  Future<void> _mapMyCollectionFetchCollections(
    MyCollectionFetchCollections event,
    Emitter<MyCollectionState> emit,
  ) async {
    _onMyCollectionClean(MyCollectionClean(), emit);
    logger.logInfo('mapMyCollectionFetchCollections', 'Fetching collections',
        {'event': event});
    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            'User ID is null. User must be logged in to fetch posts.');
      }
      logger.logInfo('mapMyCollectionFetchCollections',
          'Fetching collections for user', {'userId': userId});

      final collections = await _postRepository.getMyCollection(userId: userId);

      if (collections.isEmpty) {
        logger.logInfo('mapMyCollectionFetchCollections',
            'No collections found', {'userId': userId});
      } else {
        logger.logInfo(
            'mapMyCollectionFetchCollections',
            'Collections fetched successfully',
            {'totalCollections': collections.length});
      }

      emit(
        state.copyWith(
            collections: collections,
            status: MyCollectionStatus.loaded,
            isPostInCollection: true),
      );
    } catch (err) {
      logger.logError('mapMyCollectionFetchCollections',
          'Error fetching collections', {'error': err.toString()});
      emit(state.copyWith(
        status: MyCollectionStatus.error,
        failure:
            const Failure(message: 'Impossible de charger les collections'),
        collections: [],
        isPostInCollection: true,
      ));
    }
  }

  Future<void> _onMyCollectionClean(
    MyCollectionClean event,
    Emitter<MyCollectionState> emit,
  ) async {
    emit(MyCollectionState.initial());
  }

  Future<void> _onCheckPostInCollection(
    MyCollectionCheckPostInCollection event,
    Emitter<MyCollectionState> emit,
  ) async {
    try {
      final isPostInCollection = await _postRepository.isPostInCollection(
        postId: event.postId,
        collectionId: event.collectionId,
        userIdfromPost: event.userIdfromPost,
      );

      logger.logInfo(
          'onCheckPostInCollection', 'Checked if post is in collection', {
        'postId': event.postId,
        'collectionId': event.collectionId,
        'isPostInCollection': isPostInCollection
      });

      emit(state.copyWith(
        isPostInCollection: isPostInCollection,
      ));
    } catch (e) {
      logger.logError('onCheckPostInCollection',
          'Error checking post in collection', {'error': e.toString()});
    }
  }

  Future<void> _onDeletePostRefFromCollection(
    MyCollectionDeletePostRef event,
    Emitter<MyCollectionState> emit,
  ) async {
    try {
      await _postRepository.deletePostRefFromCollection(
          postId: event.postId, collectionId: event.collectionId);

      logger.logInfo(
          'onDeletePostRefFromCollection',
          'Post reference deleted from collection',
          {'postId': event.postId, 'collectionId': event.collectionId});

      // Vous pouvez émettre un nouvel état ici si nécessaire
      // Par exemple, recharger les collections pour refléter la suppression
    } catch (e) {
      logger.logError(
          'onDeletePostRefFromCollection',
          'Error deleting post reference from collection',
          {'error': e.toString()});
      // Gérer l'état d'erreur comme vous le souhaitez
    }
  }
}
