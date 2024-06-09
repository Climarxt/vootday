import '../../models/models.dart';

abstract class BasePostRepository {
  void createLike({required Post post, required String userId});
  Future<Set<String>> getLikedPostIds({
    required String userId,
    required List<Post> posts,
  });
  void deleteLike({required String postId, required String userId});
}
