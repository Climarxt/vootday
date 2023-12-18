import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/follow_users/followers_users/followers_users_state.dart';


class FollowersUsersCubit extends Cubit<FollowersUsersState> {
  final UserRepository _userRepository;

  FollowersUsersCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(FollowersUsersState.initial());

  void fetchUserFollowers(String userId) async {
    emit(state.copyWith(status: FollowersUsersStatus.loading));
    try {
      final followers = await _userRepository.getUserFollowers(userId: userId);
      emit(state.copyWith(followers: followers, status: FollowersUsersStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: FollowersUsersStatus.error));
    }
  }
}
