import 'package:bloc/bloc.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/repositories/collection/collection_repository.dart';

part 'update_public_status_state.dart';

class UpdatePublicStatusCubit extends Cubit<UpdatePublicStatusState> {
  final CollectionRepository _collectionRepository;
  final ContextualLogger logger;

  UpdatePublicStatusCubit({
    required CollectionRepository collectionRepository,
  })  : _collectionRepository = collectionRepository,
        logger = ContextualLogger('UpdatePublicStatusCubit'),
        super(UpdatePublicStatusInitial()) {
    logger.logInfo('UpdatePublicStatusCubit', 'Cubit created');
  }

  Future<void> updatePublicStatus(String collectionId, bool newStatus) async {
    const String functionName = 'updatePublicStatus';
    try {
      logger.logInfo(functionName, 'Updating public status',
          {'collectionId': collectionId, 'newStatus': newStatus});
      emit(UpdatePublicStatusLoading());
      await _collectionRepository.updateCollectionPublicStatus(
          collectionId: collectionId, newStatus: newStatus);
      logger.logInfo(functionName, 'Public status updated successfully',
          {'collectionId': collectionId, 'newStatus': newStatus});
      emit(UpdatePublicStatusSuccess());
    } catch (e) {
      logger.logError(functionName, 'Error updating public status', {
        'collectionId': collectionId,
        'newStatus': newStatus,
        'error': e.toString()
      });
      emit(UpdatePublicStatusError(e.toString()));
    }
  }
}
