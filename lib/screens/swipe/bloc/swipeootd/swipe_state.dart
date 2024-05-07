part of 'swipe_bloc.dart';

enum SwipeStatus { initial, loading, loaded, error }

class SwipeState extends Equatable {
  final SwipeStatus status;
  final List<Post> posts;
  final bool shouldFetch;
  final String error;

  const SwipeState._({
    this.status = SwipeStatus.initial,
    this.posts = const [],
    this.shouldFetch = true,
    this.error = '',
  });

  SwipeState.initial() : this._();

  SwipeState.loaded(List<Post> posts, {bool shouldFetch = false})
      : this._(
            status: SwipeStatus.loaded, posts: posts, shouldFetch: shouldFetch);

  SwipeState.error(String error)
      : this._(status: SwipeStatus.error, error: error);

  @override
  List<Object> get props => [status, posts, shouldFetch, error];
}
