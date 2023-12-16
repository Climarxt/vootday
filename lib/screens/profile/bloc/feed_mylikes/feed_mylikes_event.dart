part of 'feed_mylikes_bloc.dart';

abstract class FeedMyLikesEvent extends Equatable {
  const FeedMyLikesEvent();

  @override
  List<Object?> get props => [];
}

class FeedMyLikesFetchPostsCollections extends FeedMyLikesEvent {}

class FeedMyLikesClean extends FeedMyLikesEvent {}
