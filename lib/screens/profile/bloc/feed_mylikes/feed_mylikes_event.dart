part of 'feed_mylikes_bloc.dart';

abstract class FeedMyLikesEvent extends Equatable {
  const FeedMyLikesEvent();

  @override
  List<Object?> get props => [];
}

class FeedMyLikesFetchPosts extends FeedMyLikesEvent {}

class FeedMyLikesClean extends FeedMyLikesEvent {}

class FeedMyLikesCheckPostInLikes extends FeedMyLikesEvent {
  final String postId;
  final String userIdfromPost;

  const FeedMyLikesCheckPostInLikes({
    required this.postId,
    required this.userIdfromPost,
  });

  @override
  List<Object> get props => [postId, userIdfromPost];
}

class FeedMyLikesDeletePostRef extends FeedMyLikesEvent {
  final String postId;
  final String userIdfromPost;

  const FeedMyLikesDeletePostRef({
    required this.postId,
    required this.userIdfromPost,
  });

  @override
  List<Object> get props => [postId, userIdfromPost];
}
