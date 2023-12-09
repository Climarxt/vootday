part of 'feed_collection_bloc.dart';

abstract class FeedCollectionEvent extends Equatable {
  const FeedCollectionEvent();

  @override
  List<Object?> get props => [];
}

class FeedCollectionFetchPostsCollections extends FeedCollectionEvent {
  final String collectionId;

  const FeedCollectionFetchPostsCollections({required this.collectionId});

  @override
  List<Object> get props => [collectionId];
}

class FeedCollectionPaginatePostsCollections extends FeedCollectionEvent {
  final String collectionId;

  const FeedCollectionPaginatePostsCollections({required this.collectionId});

  @override
  List<Object> get props => [collectionId];
}
