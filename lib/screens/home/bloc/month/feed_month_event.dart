part of 'feed_month_bloc.dart';

abstract class FeedMonthEvent extends Equatable {
  const FeedMonthEvent();

  @override
  List<Object?> get props => [];
}

class FeedMonthFetchPosts extends FeedMonthEvent {}

class FeedMonthFetchPostsMonth extends FeedMonthEvent {}

class FeedMonthPaginatePosts extends FeedMonthEvent {}
