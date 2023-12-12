import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/repositories.dart';

part 'delete_collections_state.dart';

class DeleteCollectionsCubit extends Cubit<DeleteCollectionsState> {
  final PostRepository postRepository;

  DeleteCollectionsCubit(this.postRepository) : super(DeleteCollectionsInitial());

  Future<void> deleteCollections(String collectionId) async {
    try {
      emit(DeleteCollectionsLoading());
      postRepository.deleteCollection(collectionId: collectionId);
      emit(DeleteCollectionsSuccess());
    } catch (e) {
      emit(DeleteCollectionsError(e.toString()));
    }
  }
}
