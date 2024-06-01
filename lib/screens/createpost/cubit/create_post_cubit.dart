import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final EventRepository _eventRepository;
  final StorageRepository _storageRepository;
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  CreatePostCubit({
    required PostRepository postRepository,
    required EventRepository eventRepository,
    required StorageRepository storageRepository,
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _eventRepository = eventRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        _userRepository = userRepository,
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

  void selectedGenderChanged(String selectedGender) {
    emit(state.copyWith(
        selectedGender: selectedGender, status: CreatePostStatus.initial));
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
      final userId = _authBloc.state.user!.uid;
      final user = await _userRepository.fetchUserDetails(userId);

      final author = User.empty.copyWith(id: userId);
      final selectedGender = user.selectedGender;

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
        tags: state.tags,
        selectedGender: selectedGender,
        locationCity: user.locationCity,
        locationState: user.locationState,
        locationCountry: user.locationCountry,
        locationSelected: state.locationSelected,
      );

      // Debug print all the post values
      debugPrint('Creating post with values:');
      debugPrint('Author: ${post.author}');
      debugPrint('Image URL: ${post.imageUrl}');
      debugPrint('Thumbnail URL: ${post.thumbnailUrl}');
      debugPrint('Caption: ${post.caption}');
      debugPrint('Likes: ${post.likes}');
      debugPrint('Date: ${post.date}');
      debugPrint('Tags: ${post.tags}');
      debugPrint('Selected Gender: ${post.selectedGender}');
      debugPrint('Location City: ${post.locationCity}');
      debugPrint('Location State: ${post.locationState}');
      debugPrint('Location Country: ${post.locationCountry}');
      debugPrint('Location Selected: ${post.locationSelected}');

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

  void submitPostEvent(String eventId) async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      // Récupérer l'instance de l'événement à partir de son ID
      final Event? eventDetails = await _eventRepository.getEventById(eventId);
      if (eventDetails == null) {
        emit(
          state.copyWith(
            status: CreatePostStatus.error,
            failure: const Failure(message: 'Event not found.'),
          ),
        );
        return;
      }

      // Récupérer le nom de l'auteur (marque) à partir de l'événement
      final brandAuthorName = eventDetails.author.author;

      // Compresser et télécharger l'image originale
      final compressedImage = await compressImage(state.postImage!);
      final postImageUrl =
          await _storageRepository.uploadPostImage(image: compressedImage);

      // Compresser et créer l'image miniature
      final thumbnailImage = await createThumbnail(state.postImage!);
      final thumbnailImageBytes = await thumbnailImage.readAsBytes();
      final thumbnailImageUrl = await _storageRepository.uploadThumbnailImage(
        thumbnailImageBytes: thumbnailImageBytes,
      );

      // Créer l'objet Post avec les informations nécessaires
      final post = Post(
        author: User.empty.copyWith(id: _authBloc.state.user!.uid),
        imageUrl: postImageUrl,
        thumbnailUrl: thumbnailImageUrl,
        caption: state.caption,
        likes: 0,
        date: DateTime.now(),
        // Ajouter le nom de l'auteur (marque) aux tags existants
        tags: [brandAuthorName],
        selectedGender: state.selectedGender,
        locationCity: '',
        locationState: '',
        locationCountry: '',
        locationSelected: '',
      );

      // Créer le post dans Firestore
      await _postRepository.createPostEvent(post: post, eventId: eventId);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          failure:
              Failure(message: 'Unable to create your post: ${err.toString()}'),
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

  void locationSelectedChanged(String location) {
    emit(state.copyWith(
        locationSelected: location, status: CreatePostStatus.initial));
  }
}
