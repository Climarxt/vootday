import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/collection/collection_delete_repository.dart';
import 'package:bootdv2/config/logger/logger.dart';

part 'delete_collections_state.dart';

class DeleteCollectionsCubit extends Cubit<DeleteCollectionsState> {
  final CollectionDeleteRepository collectionDeleteRepository;
  final ContextualLogger logger;

  DeleteCollectionsCubit(this.collectionDeleteRepository)
      : logger = ContextualLogger('DeleteCollectionsCubit'),
        super(DeleteCollectionsInitial());

  Future<void> deleteCollections(String collectionId) async {
    const String functionName = 'deleteCollections';
    try {
      logger.logInfo(
          functionName, 'Deleting collection', {'collectionId': collectionId});
      emit(DeleteCollectionsLoading());
      await collectionDeleteRepository.deleteCollection(
          collectionId: collectionId);
      logger.logInfo(functionName, 'Collection deleted successfully',
          {'collectionId': collectionId});
      emit(DeleteCollectionsSuccess());
    } catch (e) {
      logger.logError(functionName, 'Error deleting collection',
          {'collectionId': collectionId, 'error': e.toString()});
      emit(DeleteCollectionsError(e.toString()));
    }
  }
}
