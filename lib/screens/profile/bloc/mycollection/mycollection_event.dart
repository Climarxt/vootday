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

  MyCollectionCheckPostInCollection({
    required this.postId,
    required this.collectionId,
  });

  @override
  List<Object> get props => [postId, collectionId];
}
