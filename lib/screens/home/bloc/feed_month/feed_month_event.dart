part of 'feed_month_bloc.dart';

abstract class FeedMonthEvent extends Equatable {
  const FeedMonthEvent();

  @override
  List<Object?> get props => [];
}

class FeedMonthFetchPosts extends FeedMonthEvent {}

class FeedMonthManFetchPostsMonth extends FeedMonthEvent {}

class FeedMonthFemaleFetchPostsMonth extends FeedMonthEvent {}

class FeedMonthPaginatePosts extends FeedMonthEvent {}
