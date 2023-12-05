part of 'following_bloc.dart';

enum FollowingStatus { initial, loading, loaded, paginating, error }

class FollowingState extends Equatable {
  final List<Post?> posts;
  final FollowingStatus status;
  final Failure failure;

  const FollowingState({
    required this.posts,
    required this.status,
    required this.failure,
  });

  factory FollowingState.initial() {
    return const FollowingState(
      posts: [],
      status: FollowingStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [posts, status, failure];

  FollowingState copyWith({
    List<Post?>? posts,
    FollowingStatus? status,
    Failure? failure,
  }) {
    return FollowingState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
