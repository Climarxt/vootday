part of 'feed_mylikes_bloc.dart';

enum FeedMyLikesStatus { initial, loading, loaded, paginating, error }

class FeedMyLikesState extends Equatable {
  final List<Post?> posts;
  final Collection? collection;
  final FeedMyLikesStatus status;
  final Failure failure;
  final bool hasFetchedInitialPosts;

  const FeedMyLikesState({
    required this.posts,
    required this.collection,
    required this.status,
    required this.failure,
    this.hasFetchedInitialPosts = false,
  });

  factory FeedMyLikesState.initial() {
    return const FeedMyLikesState(
      posts: [],
      status: FeedMyLikesStatus.initial,
      failure: Failure(),
      collection: null,
    );
  }

  @override
  List<Object?> get props => [posts, status, failure, hasFetchedInitialPosts];

  FeedMyLikesState copyWith({
    List<Post?>? posts,
    FeedMyLikesStatus? status,
    Failure? failure,
    Event? event,
    bool? hasFetchedInitialPosts,
    required bool isPostInLikes,
  }) {
    return FeedMyLikesState(
      posts: posts ?? this.posts,
      collection: collection ?? collection,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      hasFetchedInitialPosts:
          hasFetchedInitialPosts ?? this.hasFetchedInitialPosts,
    );
  }
}
