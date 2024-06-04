part of 'mycollection_bloc.dart';

abstract class MyCollectionEvent extends Equatable {
  const MyCollectionEvent();

  @override
  List<Object?> get props => [];
}

class MyCollectionFetchCollections extends MyCollectionEvent {}

class MyCollectionClean extends MyCollectionEvent {}

class MyCollectionCheckPostInCollection extends MyCollectionEvent {
  final String postId;
  final String collectionId;
  final String userIdfromPost;

  const MyCollectionCheckPostInCollection({
    required this.postId,
    required this.collectionId,
    required this.userIdfromPost,
  });

  @override
  List<Object> get props => [postId, collectionId, userIdfromPost];
}

class MyCollectionDeletePostRef extends MyCollectionEvent {
  final String postId;
  final String collectionId;

  const MyCollectionDeletePostRef({
    required this.postId,
    required this.collectionId,
  });

  @override
  List<Object> get props => [postId, collectionId];
}
