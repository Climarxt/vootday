part of 'explorer_bloc.dart';

enum ExplorerStatus { initial, loading, loaded, paginating, error }

class ExplorerState extends Equatable {
  final List<Post?> posts;
  final ExplorerStatus status;
  final Failure failure;

  const ExplorerState({
    required this.posts,
    required this.status,
    required this.failure,
  });

  factory ExplorerState.initial() {
    return const ExplorerState(
      posts: [],
      status: ExplorerStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  ExplorerState copyWith({
    List<Post?>? posts,
    ExplorerStatus? status,
    Failure? failure,
  }) {
    return ExplorerState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
