part of 'recent_post_image_url_cubit.dart';

abstract class RecentPostImageUrlState {
  const RecentPostImageUrlState();

  List<Object> get props => [];
}

class RecentPostImageUrlInitial extends RecentPostImageUrlState {}

class RecentPostImageUrlLoading extends RecentPostImageUrlState {}

class RecentPostImageUrlSuccess extends RecentPostImageUrlState {
  final String imageUrl;

  const RecentPostImageUrlSuccess(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class RecentPostImageUrlFailure extends RecentPostImageUrlState {}
