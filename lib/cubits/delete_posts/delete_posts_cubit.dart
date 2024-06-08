import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/post/post_delete_repository.dart';

part 'delete_posts_state.dart';

class DeletePostsCubit extends Cubit<DeletePostsState> {
  final PostDeleteRepository postDeleteRepository;

  DeletePostsCubit(this.postDeleteRepository) : super(DeletePostsInitial());

  Future<void> deletePosts(String postId, String userIdfromAuth) async {
    try {
      emit(DeletePostsLoading());
      postDeleteRepository.deletePost(
        postId: postId,
        userIdfromAuth: userIdfromAuth,
      );
      emit(DeletePostsSuccess());
    } catch (e) {
      emit(DeletePostsError(e.toString()));
    }
  }
}
