import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/repositories.dart';

part 'delete_posts_state.dart';

class DeletePostsCubit extends Cubit<DeletePostsState> {
  final PostRepository postRepository;

  DeletePostsCubit(this.postRepository) : super(DeletePostsInitial());

  Future<void> deletePosts(String postId, String userIdfromAuth) async {
    try {
      emit(DeletePostsLoading());
      postRepository.deletePost(
        postId: postId,
        userIdfromAuth: userIdfromAuth,
      );
      emit(DeletePostsSuccess());
    } catch (e) {
      emit(DeletePostsError(e.toString()));
    }
  }
}
