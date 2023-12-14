import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:flutter/material.dart';

part 'update_public_status_state.dart';

class UpdatePublicStatusCubit extends Cubit<UpdatePublicStatusState> {
  final PostRepository _postRepository;

  UpdatePublicStatusCubit({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(UpdatePublicStatusInitial()) {
    debugPrint('UpdatePublicStatusCubit created');
  }

  Future<void> updatePublicStatus(String collectionId, bool newStatus) async {
    try {
      emit(UpdatePublicStatusLoading());
      await _postRepository.updateCollectionPublicStatus(
          collectionId: collectionId, newStatus: newStatus);
      emit(UpdatePublicStatusSuccess());
    } catch (e) {
      emit(UpdatePublicStatusError(e.toString()));
    }
  }
}
