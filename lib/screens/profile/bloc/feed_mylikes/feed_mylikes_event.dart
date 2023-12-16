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

  const FeedMyLikesCheckPostInLikes({
    required this.postId,
  });

  @override
  List<Object> get props => [postId];
}

class FeedMyLikesDeletePostRef extends FeedMyLikesEvent {
  final String postId;
  final String userId;

  const FeedMyLikesDeletePostRef({
    required this.postId,
    required this.userId,
  });

  @override
  List<Object> get props => [postId, userId];
}
