part of 'createcollection_cubit.dart';

enum CreateCollectionStatus { initial, loading, success, error }

class CreateCollectionState extends Equatable {
  final CreateCollectionStatus status;
  final Failure failure;

  const CreateCollectionState({
    required this.status,
    required this.failure,
  });

  factory CreateCollectionState.initial() {
    return const CreateCollectionState(
      status: CreateCollectionStatus.initial,
      failure: Failure(),
    );
  }

  CreateCollectionState copyWith({
    CreateCollectionStatus? status,
    Failure? failure,
  }) {
    return CreateCollectionState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [status, failure];
}

class Failure extends Equatable {
  final String message;

  const Failure({this.message = ''});

  @override
  List<Object> get props => [message];
}
