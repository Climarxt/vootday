part of 'following_bloc.dart';

abstract class FollowingEvent extends Equatable {
  const FollowingEvent();

  @override
  List<Object?> get props => [];
}

class FollowingFetchPosts extends FollowingEvent {}

class FollowingPaginatePosts extends FollowingEvent {}
