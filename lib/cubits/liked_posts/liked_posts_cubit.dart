import 'package:bloc/bloc.dart';
import 'package:bootdv2/repositories/like/like_repository.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';

part 'liked_posts_state.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  final LikeRepository _likeRepository;
  final AuthBloc _authBloc;

  LikedPostsCubit({
    required LikeRepository likeRepository,
    required AuthBloc authBloc,
  })  : _likeRepository = likeRepository,
        _authBloc = authBloc,
        super(LikedPostsState.initial());

  void updateLikedPosts({required Set<String> postIds}) {
    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds),
      ),
    );
  }

  void likePost({required Post post}) {
    _likeRepository.createLike(
      post: post,
      userId: _authBloc.state.user!.uid,
    );

    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id!),
        recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
          ..add(post.id!),
      ),
    );
  }

  void unlikePost({required Post post}) {
    _likeRepository.deleteLike(
      postId: post.id!,
      userId: _authBloc.state.user!.uid,
    );

    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..remove(post.id),
        recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
          ..remove(post.id),
      ),
    );
  }

  void clearAllLikedPosts() {
    emit(LikedPostsState.initial());
  }
}
