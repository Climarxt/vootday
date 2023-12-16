import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

part 'package:bootdv2/screens/profile/bloc/mycollection/mycollection_state.dart';
part 'package:bootdv2/screens/profile/bloc/mycollection/mycollection_event.dart';

class MyCollectionBloc extends Bloc<MyCollectionEvent, MyCollectionState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  MyCollectionBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(MyCollectionState.initial()) {
    on<MyCollectionFetchCollections>(_mapMyCollectionFetchCollections);
    on<MyCollectionClean>(_onMyCollectionClean);
    on<MyCollectionCheckPostInCollection>(_onCheckPostInCollection);
  }

  Future<void> _mapMyCollectionFetchCollections(
    MyCollectionFetchCollections event,
    Emitter<MyCollectionState> emit,
  ) async {
    _onMyCollectionClean(MyCollectionClean(), emit);
    try {
      final userId = _authBloc.state.user?.uid;
      if (userId == null) {
        throw Exception(
            '_mapMyCollectionFetchCollections : User ID is null. User must be logged in to fetch posts.');
      }
      debugPrint('_mapMyCollectionFetchCollections : Fetching collections...');
      final collections = await _postRepository.getMyCollection(userId: userId);

      if (collections.isEmpty) {
        debugPrint('_mapMyCollectionFetchCollections : No collections found.');
      } else {
        debugPrint(
            '_mapMyCollectionFetchCollections : Collections fetched successfully. Total collections: ${collections.length}');
      }

      emit(
        state.copyWith(
            collections: collections,
            status: MyCollectionStatus.loaded,
            isPostInCollection: true),
      );
    } catch (err) {
      debugPrint(
          '_mapMyCollectionFetchCollections : Error fetching collections: ${err.toString()}');

      emit(state.copyWith(
        status: MyCollectionStatus.error,
        failure: const Failure(
            message:
                '_mapMyCollectionFetchCollections : Impossible de charger les collections'),
        collections: [],
        isPostInCollection: true,
      ));
    }
  }

  Future<void> _onMyCollectionClean(
    MyCollectionClean event,
    Emitter<MyCollectionState> emit,
  ) async {
    emit(MyCollectionState.initial()); // Remet l'état à son état initial
  }

  Future<void> _onCheckPostInCollection(
    MyCollectionCheckPostInCollection event,
    Emitter<MyCollectionState> emit,
  ) async {
    try {
      final isPostInCollection = await _postRepository.isPostInCollection(
        postId: event.postId,
        collectionId: event.collectionId,
      );

      emit(state.copyWith(
        isPostInCollection: isPostInCollection,
      ));
    } catch (e) {
      debugPrint('Error checking post in collection: ${e.toString()}');
      // Vous pouvez également émettre un état d'erreur ici si nécessaire
    }
  }
}
