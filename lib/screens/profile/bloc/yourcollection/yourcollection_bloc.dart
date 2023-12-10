import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

part 'package:bootdv2/screens/profile/bloc/yourcollection/yourcollection_state.dart';
part 'package:bootdv2/screens/profile/bloc/yourcollection/yourcollection_event.dart';

class YourCollectionBloc extends Bloc<YourCollectionEvent, YourCollectionState> {
  final PostRepository _postRepository;

  YourCollectionBloc({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(YourCollectionState.initial()) {
    on<YourCollectionFetchCollections>(_mapYourCollectionFetchCollections);
    on<YourCollectionClean>(_onYourCollectionClean);
  }

  Future<void> _mapYourCollectionFetchCollections(
    YourCollectionFetchCollections event,
    Emitter<YourCollectionState> emit,
  ) async {
    _onYourCollectionClean(YourCollectionClean(), emit);
    try {
      debugPrint(
          'Method _mapYourCollectionFetchCollections : Fetching collections...');
      final collections = await _postRepository.getYourCollection(
        userId: event.userId,
      );

      if (collections.isEmpty) {
        debugPrint(
            'Method _mapYourCollectionFetchCollections : No collections found.');
      } else {
        debugPrint(
            'Method _mapYourCollectionFetchCollections : Collections fetched successfully. Total collections: ${collections.length}');
      }

      emit(
        state.copyWith(
            collections: collections, status: YourCollectionStatus.loaded),
      );
    } catch (err) {
      debugPrint(
          'Method _mapYourCollectionFetchCollections : Error fetching collections: ${err.toString()}');

      emit(state.copyWith(
        status: YourCollectionStatus.error,
        failure: const Failure(
            message:
                'Method _mapYourCollectionFetchCollections : Impossible de charger les collections'),
        collections: [],
      ));
    }
  }

  Future<void> _onYourCollectionClean(
    YourCollectionClean event,
    Emitter<YourCollectionState> emit,
  ) async {
    emit(YourCollectionState.initial()); // Remet l'état à son état initial
  }
}
