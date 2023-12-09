import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/collection_model.dart';
import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/repositories/repositories.dart';

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
  }

  Future<void> _mapMyCollectionFetchCollections(
    MyCollectionFetchCollections event,
    Emitter<MyCollectionState> emit,
  ) async {
    try {
      debugPrint(
          'Method _mapMyCollectionFetchCollections : Fetching collections...');
      final collections = await _postRepository.getMyCollection(
        userId: _authBloc.state.user!.uid,
      );

      if (collections.isEmpty) {
        debugPrint(
            'Method _mapMyCollectionFetchCollections : No collections found.');
      } else {
        debugPrint(
            'Method _mapMyCollectionFetchCollections : Collections fetched successfully. Total collections: ${collections.length}');
      }

      emit(
        state.copyWith(
            collections: collections, status: MyCollectionStatus.loaded),
      );
    } catch (err) {
      debugPrint(
          'Method _mapMyCollectionFetchCollections : Error fetching collections: ${err.toString()}');

      emit(state.copyWith(
        status: MyCollectionStatus.error,
        failure: const Failure(
            message:
                'Method _mapMyCollectionFetchCollections : Impossible de charger les collections'),
        collections: [],
      ));
    }
  }
}
