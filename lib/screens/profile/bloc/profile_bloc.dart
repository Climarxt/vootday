import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  StreamSubscription? _authSubscription;

  StreamSubscription<List<Future<Post?>>>? _postsSubscription;

  ProfileBloc({
    required AuthBloc authBloc,
    required UserRepository userRepository,
    required PostRepository postRepository,
  })  : _authBloc = authBloc,
        _userRepository = userRepository,
        _postRepository = postRepository,
        super(ProfileState.initial()) {
    on<ProfileLoadUser>(_onProfileLoadUser);
    on<UpdateProfile>(_onUpdateProfile);
    on<ProfileToggleGridView>(_mapProfileToggleGridViewToState);
    on<ProfileUpdatePosts>(_mapProfileUpdatePostsToState);
    on<ProfileFollowUser>(_mapProfileFollowUserToState);
    on<ProfileUnfollowUser>(_mapProfileUnfollowUserToState);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          add(ProfileLoadUser(userId: state.user!.uid));
        }
      }
    });
  }

  void _onProfileLoadUser(
    ProfileLoadUser event,
    Emitter<ProfileState> emit,
  ) {
    _postsSubscription?.cancel();
    _postsSubscription = _postRepository
        .getUserPosts(userId: event.userId)
        .listen((posts) async {
      final allPosts = await Future.wait(posts);

      add(ProfileUpdatePosts(posts: allPosts));
    });

    _userRepository.getUser(event.userId).listen((user) {
      add(
        UpdateProfile(user: user, userId: event.userId),
      );
      state.copyWith(status: ProfileStatus.loading);
    });
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    state.copyWith(status: ProfileStatus.loading);
    try {
      final isCurrentUser = _authBloc.state.user!.uid == event.userId;

      final isFollowing = await _userRepository.isFollowing(
        userId: _authBloc.state.user!.uid,
        otherUserId: event.userId,
      );

      _postsSubscription?.cancel();
      _postsSubscription = _postRepository
          .getUserPosts(userId: event.userId)
          .listen((posts) async {
        final allPosts = await Future.wait(posts);

        add(ProfileUpdatePosts(posts: allPosts));
      });

      emit(state.copyWith(
        user: event.user,
        posts: [],
        isCurrentUser: isCurrentUser,
        isFollowing: isFollowing,
        status: ProfileStatus.loaded,
      ));
    } catch (err) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'We were unable to load this profile.'),
      ));
    }
  }

  Future<void> _mapProfileUpdatePostsToState(
    ProfileUpdatePosts event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        posts: event.posts,
      ),
    );
  }

  Future<void> _mapProfileToggleGridViewToState(
    ProfileToggleGridView event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        isGridView: event.isGridView,
      ),
    );
  }

  Future<void> _mapProfileFollowUserToState(
    ProfileFollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      _userRepository.followUser(
        userId: _authBloc.state.user!.uid,
        followUserId: state.user.id,
      );
      final updatedUser =
          state.user.copyWith(followers: state.user.followers + 1);
      emit(
        state.copyWith(user: updatedUser, isFollowing: true),
      );
    } catch (err) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        failure:
            const Failure(message: 'Something went wrong! Please try again.'),
      ));
    }
  }

  Future<void> _mapProfileUnfollowUserToState(
    ProfileUnfollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      _userRepository.unfollowUser(
        userId: _authBloc.state.user!.uid,
        unfollowUserId: state.user.id,
      );
      final updatedUser =
          state.user.copyWith(followers: state.user.followers - 1);
      emit(state.copyWith(user: updatedUser, isFollowing: false));
    } catch (err) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        failure:
            const Failure(message: 'Something went wrong! Please try again.'),
      ));
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}
