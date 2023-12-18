import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/follow_users/following_users/following_users_state.dart';

class FollowingUsersCubit extends Cubit<FollowingUsersState> {
  final UserRepository _userRepository;

  FollowingUsersCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(FollowingUsersState.initial());

  void fetchUserFollowers(String userId) async {
    debugPrint('FollowingUsersCubit : Loading followers for user $userId');
    emit(state.copyWith(status: FollowingUsersStatus.loading));
    try {
      final followers = await _userRepository.getUserFollowers(userId: userId);
      debugPrint('FollowingUsersCubit : Loaded followers successfully');
      emit(state.copyWith(
          followers: followers, status: FollowingUsersStatus.loaded));
    } catch (e) {
      debugPrint(
          'FollowingUsersCubit : Failed to load followers - ${e.toString()}');
      emit(state.copyWith(status: FollowingUsersStatus.error));
    }
  }
}
