import '../../models/models.dart';

abstract class BasePostRepository {
  Future<void> createPost(
      {required Post post, required String userId, required DateTime dateTime});
  Future<void> createComment({required Post post, required Comment comment});
  void createLike({required Post post, required String userId});
  Stream<List<Future<Post?>>> getUserPosts({required String userId});
  Stream<List<Future<Comment?>>> getPostComments({required String postId});
  Future<Set<String>> getLikedPostIds({
    required String userId,
    required List<Post> posts,
  });
  void deleteLike({required String postId, required String userId});
}
