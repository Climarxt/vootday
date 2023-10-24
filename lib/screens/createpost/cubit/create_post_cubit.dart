import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;

  CreatePostCubit({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  Future<File> compressImage(File imageFile, {int quality = 90}) async {
    final filePath = imageFile.absolute.path;
    final lastIndex = filePath.lastIndexOf(Platform.pathSeparator);
    final newPath = filePath.substring(0, lastIndex);
    final compressedXImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$newPath/compressed.jpg',
      quality: quality,
    );
    final compressedImage = File(compressedXImage!.path);
    return compressedImage;
  }

  Future<File> createThumbnail(File thumbnailFile, {int quality = 50}) async {
    final filePath = thumbnailFile.absolute.path;
    final lastIndex = filePath.lastIndexOf(Platform.pathSeparator);
    final newPath = filePath.substring(0, lastIndex);
    final thumbnailXImageBytes = await FlutterImageCompress.compressAndGetFile(
      thumbnailFile.absolute.path,
      '$newPath/thumbnailcompressed.jpg',
      quality: quality,
    );
    final thumbnailImageBytes = File(thumbnailXImageBytes!.path);

    return thumbnailImageBytes;
  }

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void addTag(String tag) {
    if (tag.isNotEmpty && !state.tags.contains(tag)) {
      // Avoid adding empty or duplicate tags
      final updatedTags = List<String>.from(state.tags)..add(tag);
      emit(state.copyWith(tags: updatedTags, status: CreatePostStatus.initial));
    }
  }

  void removeTag(String tag) {
    final updatedTags = List<String>.from(state.tags)..remove(tag);
    emit(state.copyWith(tags: updatedTags, status: CreatePostStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user!.uid);

      // Compress and upload the original image
      final compressedImage = await compressImage(state.postImage!);
      final postImageUrl =
          await _storageRepository.uploadPostImage(image: compressedImage);

      // Compress and create the thumbnail image
      final thumbnailImage = await createThumbnail(state.postImage!);

      // Read the thumbnail image as bytes
      final thumbnailImageBytes = await thumbnailImage.readAsBytes();

      // Create and upload the thumbnail
      final thumbnailImageUrl = await _storageRepository.uploadThumbnailImage(
          thumbnailImageBytes: thumbnailImageBytes);

      final post = Post(
          author: author,
          imageUrl: postImageUrl,
          thumbnailUrl: thumbnailImageUrl,
          caption: state.caption,
          likes: 0,
          date: DateTime.now(),
          tags: state.tags);

      await _postRepository.createPost(post: post);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          failure:
              const Failure(message: 'We were unable to create your post.'),
        ),
      );
    }
  }

  void tagsChanged(List<String> tags) => emit(state.copyWith(tags: tags));

  void initializeTags(List<String> tags) {
    emit(state.copyWith(tags: tags));
  }

  void reset() {
    emit(CreatePostState.initial());
  }
}
