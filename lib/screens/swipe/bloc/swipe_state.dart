part of 'swipe_bloc.dart';

enum SwipeStatus { initial, loaded, error }

class SwipeState extends Equatable {
  final SwipeStatus status;
  final List<Post> posts;
  final String error;

  const SwipeState._({
    this.status = SwipeStatus.initial,
    this.posts = const [],
    this.error = '',
  });

  SwipeState.initial() : this._();

  SwipeState.loaded(List<Post> posts)
      : this._(status: SwipeStatus.loaded, posts: posts);

  SwipeState.error(String error)
      : this._(status: SwipeStatus.error, error: error);

  @override
  List<Object> get props => [status, posts, error];
}
