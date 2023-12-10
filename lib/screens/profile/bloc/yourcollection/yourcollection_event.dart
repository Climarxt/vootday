part of 'yourcollection_bloc.dart';

abstract class YourCollectionEvent extends Equatable {
  const YourCollectionEvent();

  @override
  List<Object?> get props => [];
}

class YourCollectionFetchCollections extends YourCollectionEvent {
  final String userId;

  const YourCollectionFetchCollections({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class YourCollectionClean extends YourCollectionEvent {}
