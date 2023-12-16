part of 'feed_mylikes_bloc.dart';

enum FeedMyLikesStatus { initial, loading, loaded, paginating, error }

class FeedMyLikesState extends Equatable {
  final List<Post?> posts;
  final Collection? collection;
  final FeedMyLikesStatus status;
  final Failure failure;
  final bool hasFetchedInitialPosts;
  final bool isPostInLikes; // Ajoutez ce champ

  const FeedMyLikesState({
    required this.posts,
    required this.collection,
    required this.status,
    required this.failure,
    this.hasFetchedInitialPosts = false,
    this.isPostInLikes = false,
  });

  factory FeedMyLikesState.initial() {
    return const FeedMyLikesState(
      posts: [],
      status: FeedMyLikesStatus.initial,
      failure: Failure(),
      collection: null,
      isPostInLikes: false,
    );
  }

  FeedMyLikesState copyWith({
    List<Post?>? posts,
    FeedMyLikesStatus? status,
    Failure? failure,
    Event? event,
    bool? hasFetchedInitialPosts,
    bool? isPostInLikes,
  }) {
    return FeedMyLikesState(
      posts: posts ?? this.posts,
      collection: collection ?? collection,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      hasFetchedInitialPosts:
          hasFetchedInitialPosts ?? this.hasFetchedInitialPosts,
      isPostInLikes: isPostInLikes ?? this.isPostInLikes,
    );
  }

  @override
  List<Object?> get props =>
      [posts, status, failure, hasFetchedInitialPosts, isPostInLikes];
}
