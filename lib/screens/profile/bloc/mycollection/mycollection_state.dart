part of 'mycollection_bloc.dart';

enum MyCollectionStatus { initial, loading, loaded, paginating, error }

class MyCollectionState extends Equatable {
  final List<Collection?> collections;
  final MyCollectionStatus status;
  final Failure failure;

  const MyCollectionState({
    required this.collections,
    required this.status,
    required this.failure,
  });

  factory MyCollectionState.initial() {
    return const MyCollectionState(
      collections: [],
      status: MyCollectionStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [collections, status, failure];

  MyCollectionState copyWith({
    List<Collection?>? collections,
    MyCollectionStatus? status,
    Failure? failure
  }) {
    return MyCollectionState(
      collections: collections ?? this.collections,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
