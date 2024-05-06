part of 'swipe_event_bloc.dart';

abstract class SwipeEventEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SwipeEventManFetchPosts extends SwipeEventEvent {}

class SwipeEventWomanFetchPosts extends SwipeEventEvent {}