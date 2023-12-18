import 'package:bootdv2/models/models.dart';
import 'package:equatable/equatable.dart';

enum FollowersUsersStatus { initial, loading, loaded, error }

class FollowersUsersState extends Equatable {
  final List<User> followers;
  final FollowersUsersStatus status;

  const FollowersUsersState({
    required this.followers,
    required this.status,
  });

  static FollowersUsersState initial() {
    return const FollowersUsersState(
        followers: [], status: FollowersUsersStatus.initial);
  }

  FollowersUsersState copyWith({
    List<User>? followers,
    FollowersUsersStatus? status,
  }) {
    return FollowersUsersState(
      followers: followers ?? this.followers,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [followers, status];
}
