part of 'home_event_bloc.dart';

abstract class HomeEventEvent extends Equatable {
  const HomeEventEvent();

  @override
  List<Object?> get props => [];
}

class HomeEventFetchPosts extends HomeEventEvent {}

class HomeEventFetchPostsMonth extends HomeEventEvent {}

class HomeEventPaginateEvents extends HomeEventEvent {}

class HomeEventFetchEvents extends HomeEventEvent {}