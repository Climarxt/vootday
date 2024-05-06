part of 'swipe_bloc.dart';

abstract class SwipeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SwipeFetchPostsOOTDMan extends SwipeEvent {}

class SwipeFetchPostsOOTDWoman extends SwipeEvent {}