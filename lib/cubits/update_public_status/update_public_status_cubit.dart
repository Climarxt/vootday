import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/collection/collection_repository.dart';
import 'package:flutter/material.dart';

part 'update_public_status_state.dart';

class UpdatePublicStatusCubit extends Cubit<UpdatePublicStatusState> {
  final CollectionRepository _collectionRepository;

  UpdatePublicStatusCubit({
    required CollectionRepository collectionRepository,
  })  : _collectionRepository = collectionRepository,
        super(UpdatePublicStatusInitial()) {
    debugPrint('UpdatePublicStatusCubit created');
  }

  Future<void> updatePublicStatus(String collectionId, bool newStatus) async {
    try {
      emit(UpdatePublicStatusLoading());
      await _collectionRepository.updateCollectionPublicStatus(
          collectionId: collectionId, newStatus: newStatus);
      emit(UpdatePublicStatusSuccess());
    } catch (e) {
      emit(UpdatePublicStatusError(e.toString()));
    }
  }
}
