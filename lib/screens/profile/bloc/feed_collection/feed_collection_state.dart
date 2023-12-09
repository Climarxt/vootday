part of 'feed_collection_bloc.dart';

enum FeedCollectionStatus { initial, loading, loaded, paginating, error }

class FeedCollectionState extends Equatable {
  final List<Post?> posts;
  final Collection? collection;
  final FeedCollectionStatus status;
  final Failure failure;
  final bool hasFetchedInitialPosts; 

  const FeedCollectionState({
    required this.posts,
    required this.collection,
    required this.status,
    required this.failure,
    this.hasFetchedInitialPosts = false,
  });

  factory FeedCollectionState.initial() {
    return const FeedCollectionState(
      posts: [],
      status: FeedCollectionStatus.initial,
      failure: Failure(),
      collection: null,
    );
  }

  @override
  List<Object?> get props => [posts, status, failure, hasFetchedInitialPosts];

  FeedCollectionState copyWith({
    List<Post?>? posts,
    FeedCollectionStatus? status,
    Failure? failure,
    Event? event,
    bool? hasFetchedInitialPosts,
  }) {
    return FeedCollectionState(
      posts: posts ?? this.posts,
      collection: collection ?? collection,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      hasFetchedInitialPosts: hasFetchedInitialPosts ?? this.hasFetchedInitialPosts, 
    );
  }
}
