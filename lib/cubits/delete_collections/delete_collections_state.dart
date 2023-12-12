part of 'delete_collections_cubit.dart';

abstract class DeleteCollectionsState {}

class DeleteCollectionsInitial extends DeleteCollectionsState {}

class DeleteCollectionsLoading extends DeleteCollectionsState {}

class DeleteCollectionsSuccess extends DeleteCollectionsState {}

class DeleteCollectionsError extends DeleteCollectionsState {
  final String message;

  DeleteCollectionsError(this.message);
}
