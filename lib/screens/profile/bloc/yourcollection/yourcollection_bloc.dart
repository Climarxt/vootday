import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/collection/collection_repository.dart';
import 'package:equatable/equatable.dart';

part 'package:bootdv2/screens/profile/bloc/yourcollection/yourcollection_state.dart';
part 'package:bootdv2/screens/profile/bloc/yourcollection/yourcollection_event.dart';

class YourCollectionBloc extends Bloc<YourCollectionEvent, YourCollectionState> {
  final CollectionRepository _collectionRepository;
  final ContextualLogger logger;

  YourCollectionBloc({
    required CollectionRepository collectionRepository,
  })  : _collectionRepository = collectionRepository,
        logger = ContextualLogger('YourCollectionBloc'),
        super(YourCollectionState.initial()) {
    on<YourCollectionFetchCollections>(_mapYourCollectionFetchCollections);
    on<YourCollectionClean>(_onYourCollectionClean);
  }

  Future<void> _mapYourCollectionFetchCollections(
    YourCollectionFetchCollections event,
    Emitter<YourCollectionState> emit,
  ) async {
    const String functionName = '_mapYourCollectionFetchCollections';
    _onYourCollectionClean(YourCollectionClean(), emit);
    try {
      logger.logInfo(functionName, 'Fetching collections...', {'userId': event.userId});
      final collections = await _collectionRepository.getYourCollection(userId: event.userId);

      if (collections.isEmpty) {
        logger.logInfo(functionName, 'No collections found.', {'userId': event.userId});
      } else {
        logger.logInfo(functionName, 'Collections fetched successfully.', {
          'userId': event.userId,
          'totalCollections': collections.length
        });
      }

      emit(state.copyWith(
        collections: collections,
        status: YourCollectionStatus.loaded,
      ));
    } catch (err) {
      logger.logError(functionName, 'Error fetching collections.', {
        'userId': event.userId,
        'error': err.toString(),
      });

      emit(state.copyWith(
        status: YourCollectionStatus.error,
        failure: const Failure(message: 'Impossible de charger les collections'),
        collections: [],
      ));
    }
  }

  Future<void> _onYourCollectionClean(
    YourCollectionClean event,
    Emitter<YourCollectionState> emit,
  ) async {
    emit(YourCollectionState.initial());
  }
}
