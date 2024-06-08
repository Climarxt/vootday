import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/post_create_repository.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostCreateRepository _postCreateRepository;
  final EventRepository _eventRepository;
  final StorageRepository _storageRepository;
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  final ContextualLogger logger;

  CreatePostCubit({
    required PostCreateRepository postCreateRepository,
    required EventRepository eventRepository,
    required StorageRepository storageRepository,
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _postCreateRepository = postCreateRepository,
        _eventRepository = eventRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        _userRepository = userRepository,
        logger = ContextualLogger('CreatePostCubit'),
        super(CreatePostState.initial());

  Future<File> compressImage(File imageFile, {int quality = 90}) async {
    const String functionName = 'compressImage';
    try {
      final filePath = imageFile.absolute.path;
      final lastIndex = filePath.lastIndexOf(Platform.pathSeparator);
      final newPath = filePath.substring(0, lastIndex);
      final compressedXImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        '$newPath/compressed.jpg',
        quality: quality,
      );
      final compressedImage = File(compressedXImage!.path);

      logger.logInfo(functionName, 'Image compressed successfully',
          {'filePath': filePath, 'newPath': newPath, 'quality': quality});

      return compressedImage;
    } catch (e) {
      logger.logError(
          functionName, 'Error compressing image', {'error': e.toString()});
      rethrow;
    }
  }

  Future<File> createThumbnail(File thumbnailFile, {int quality = 50}) async {
    const String functionName = 'createThumbnail';
    try {
      final filePath = thumbnailFile.absolute.path;
      final lastIndex = filePath.lastIndexOf(Platform.pathSeparator);
      final newPath = filePath.substring(0, lastIndex);
      final thumbnailXImageBytes =
          await FlutterImageCompress.compressAndGetFile(
        thumbnailFile.absolute.path,
        '$newPath/thumbnailcompressed.jpg',
        quality: quality,
      );
      final thumbnailImageBytes = File(thumbnailXImageBytes!.path);

      logger.logInfo(functionName, 'Thumbnail created successfully',
          {'filePath': filePath, 'newPath': newPath, 'quality': quality});

      return thumbnailImageBytes;
    } catch (e) {
      logger.logError(
          functionName, 'Error creating thumbnail', {'error': e.toString()});
      rethrow;
    }
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
    const String functionName = 'submit';
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final userId = _authBloc.state.user!.uid;
      final user = await _userRepository.fetchUserDetails(userId);

      final author = User.empty.copyWith(id: userId);
      final selectedGender = user.selectedGender;

      // Compresser et télécharger l'image originale
      final compressedImage = await compressImage(state.postImage!);
      final postImageUrl =
          await _storageRepository.uploadPostImage(image: compressedImage);

      // Compresser et créer l'image miniature
      final thumbnailImage = await createThumbnail(state.postImage!);

      // Lire l'image miniature en tant que bytes
      final thumbnailImageBytes = await thumbnailImage.readAsBytes();

      // Créer et télécharger l'image miniature
      final thumbnailImageUrl = await _storageRepository.uploadThumbnailImage(
          thumbnailImageBytes: thumbnailImageBytes);

      final dateTime = DateTime.now();

      final post = Post(
        author: author,
        imageUrl: postImageUrl,
        thumbnailUrl: thumbnailImageUrl,
        caption: state.caption,
        likes: 0,
        date: dateTime,
        tags: state.tags,
        selectedGender: selectedGender,
        locationCity: user.locationCity,
        locationState: user.locationState,
        locationCountry: user.locationCountry,
        locationSelected: state.locationSelected,
      );

      logger.logInfo(functionName, 'Creating post with values', {
        'author': post.author,
        'imageUrl': post.imageUrl,
        'thumbnailUrl': post.thumbnailUrl,
        'caption': post.caption,
        'likes': post.likes,
        'date': post.date,
        'tags': post.tags,
        'selectedGender': post.selectedGender,
        'locationCity': post.locationCity,
        'locationState': post.locationState,
        'locationCountry': post.locationCountry,
        'locationSelected': post.locationSelected
      });

      await _postCreateRepository.createPost(
          post: post, userId: userId, dateTime: dateTime);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      logger.logError(
          functionName, 'Error creating post', {'error': err.toString()});
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
    const String functionName = 'submitPostEvent';
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      // Récupérer l'instance de l'événement à partir de son ID
      final Event? eventDetails = await _eventRepository.getEventById(eventId);
      if (eventDetails == null) {
        logger.logError(functionName, 'Event not found', {'eventId': eventId});
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

      logger.logInfo(functionName, 'Creating event post with values', {
        'eventId': eventId,
        'author': post.author,
        'imageUrl': post.imageUrl,
        'thumbnailUrl': post.thumbnailUrl,
        'caption': post.caption,
        'likes': post.likes,
        'date': post.date,
        'tags': post.tags,
        'selectedGender': post.selectedGender
      });

      // Créer le post dans Firestore
      await _postCreateRepository.createPostEvent(post: post, eventId: eventId);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      logger.logError(
          functionName, 'Error creating event post', {'error': err.toString()});
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
