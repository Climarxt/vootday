part of 'swipe_event_bloc.dart';

enum SwipeEventStatus { initial, loading, loaded, error }

class SwipeEventState extends Equatable {
  final SwipeEventStatus status;
  final List<Post> posts;
  final String error;

  const SwipeEventState._({
    this.status = SwipeEventStatus.initial,
    this.posts = const [],
    this.error = '',
  });

  const SwipeEventState.initial() : this._();

  const SwipeEventState.loaded(List<Post> posts)
      : this._(status: SwipeEventStatus.loaded, posts: posts);

  const SwipeEventState.error(String error)
      : this._(status: SwipeEventStatus.error, error: error);

  @override
  List<Object> get props => [status, posts, error];
}
