part of 'mycollection_bloc.dart';

abstract class MyCollectionEvent extends Equatable {
  const MyCollectionEvent();

  @override
  List<Object?> get props => [];
}

class MyCollectionFetchCollections extends MyCollectionEvent {}

class MyCollectionClean extends MyCollectionEvent {}
