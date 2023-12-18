import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';

enum FollowingUsersStatus { initial, loading, loaded, error }

class FollowingUsersState extends Equatable {
  final List<User> followers;
  final FollowingUsersStatus status;

  const FollowingUsersState({
    required this.followers,
    required this.status,
  });

  static FollowingUsersState initial() {
    return const FollowingUsersState(
        followers: [], status: FollowingUsersStatus.initial);
  }

  FollowingUsersState copyWith({
    List<User>? followers,
    FollowingUsersStatus? status,
  }) {
    return FollowingUsersState(
      followers: followers ?? this.followers,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [followers, status];
}
