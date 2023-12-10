part of 'yourcollection_bloc.dart';

enum YourCollectionStatus { initial, loading, loaded, paginating, error }

class YourCollectionState extends Equatable {
  final List<Collection?> collections;
  final YourCollectionStatus status;
  final Failure failure;

  const YourCollectionState({
    required this.collections,
    required this.status,
    required this.failure,
  });

  factory YourCollectionState.initial() {
    return const YourCollectionState(
      collections: [],
      status: YourCollectionStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [collections, status, failure];

  YourCollectionState copyWith({
    List<Collection?>? collections,
    YourCollectionStatus? status,
    Failure? failure
  }) {
    return YourCollectionState(
      collections: collections ?? this.collections,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
