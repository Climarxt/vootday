// ignore_for_file: avoid_print

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/repositories/post/base_post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  @override
  Future<void> createComment({
    required Post post,
    required Comment comment,
  }) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument());

    final notification = Notif(
      type: NotifType.comment,
      fromUser: comment.author,
      post: post,
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(post.author.id)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  @override
  void createLike({
    required Post post,
    required String userId,
  }) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(post.id)
        .collection(Paths.postLikes)
        .doc(userId)
        .set({});

    final notification = Notif(
      type: NotifType.like,
      fromUser: User.empty.copyWith(id: userId),
      post: post,
      date: DateTime.now(),
    );

    _firebaseFirestore
        .collection(Paths.notifications)
        .doc(post.author.id)
        .collection(Paths.userNotifications)
        .add(notification.toDocument());
  }

  @override
  Stream<List<Future<Post?>>> getUserPosts({required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  @override
  Stream<List<Future<Comment?>>> getPostComments({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

  @override
  Future<List<Post?>> getUserFeed({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.posts)
          .orderBy('date', descending: true)
          .limit(5)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.posts)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.posts)
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(3)
          .get();
    }

    final posts = Future.wait(
      postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList(),
    );
    return posts;
  }

  Future<List<Post?>> getFeedOOTD({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotd)
          .orderBy('likes', descending: true)
          .limit(100)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedOotd)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedOotd)
          .orderBy('likes', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(2)
          .get();
    }

    List<Future<Post?>> postFutures = postsSnap.docs.map((doc) async {
      DocumentReference postRef = doc['post_ref'];
      DocumentSnapshot postSnap = await postRef.get();
      if (postSnap.exists) {
        return Post.fromDocument(postSnap);
      }
      return null;
    }).toList();

    final posts = await Future.wait(postFutures);
    return posts;
  }

  Future<List<Post?>> getFeedMonth({
    required String userId,
    String? lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonth)
          .orderBy('likes', descending: true)
          .limit(5)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feedMonth)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.feedMonth)
          .orderBy('likes', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(3)
          .get();
    }

    final posts = Future.wait(
      postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList(),
    );
    return posts;
  }

  @override
  Future<Set<String>> getLikedPostIds({
    required String userId,
    required List<Post?> posts,
  }) async {
    final postIds = <String>{};
    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection(Paths.likes)
          .doc(post!.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .get();
      if (likeDoc.exists) {
        postIds.add(post.id!);
      }
    }
    return postIds;
  }

  @override
  void deleteLike({required String postId, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .doc(userId)
        .delete();
  }

  Future<Post?> getPostById(String postId) async {
  try {
    DocumentSnapshot postSnap = await _firebaseFirestore.collection(Paths.posts).doc(postId).get();

    if (postSnap.exists) {
      return Post.fromDocument(postSnap);
    } else {
      // Handle the case where the post does not exist.
      print("Le post n'existe pas.");
      return null;
    }
  } catch (e) {
    // Handle any errors that occur during the fetch.
    print(e.toString());
    return null;
  }
}

}
