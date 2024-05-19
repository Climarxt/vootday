import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final ProfileBloc _profileBloc;

  EditProfileCubit({
    required UserRepository userRepository,
    required StorageRepository storageRepository,
    required ProfileBloc profileBloc,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _profileBloc = profileBloc,
        super(EditProfileState.initial()) {
    final user = _profileBloc.state.user;
    emit(state.copyWith(username: user.username, bio: user.bio));
  }

  void usernameChanged(String username) {
    emit(
      state.copyWith(username: username, status: EditProfileStatus.initial),
    );
  }

  void submitUsernameChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final usernameLowercase = state.username.toLowerCase();

      final updatedUser = user.copyWith(
        username: state.username,
        username_lowercase: usernameLowercase,
      );

      await _userRepository.updateUser(user: updatedUser);

      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your username.',
            ),
          ),
        );
      }
    }
  }

  void firstnameChanged(String firstname) {
    emit(
      state.copyWith(firstName: firstname, status: EditProfileStatus.initial),
    );
  }

  void submitFirstNameChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final updatedUser = user.copyWith(firstName: state.firstName);
      await _userRepository.updateUser(user: updatedUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your first name.',
            ),
          ),
        );
      }
    }
  }

  void lastnameChanged(String lastName) {
    emit(
      state.copyWith(lastName: lastName, status: EditProfileStatus.initial),
    );
  }

  void submitLastNameChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final updatedUser = user.copyWith(lastName: state.lastName);
      await _userRepository.updateUser(user: updatedUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your last name.',
            ),
          ),
        );
      }
    }
  }

  void bioChanged(String bio) {
    emit(
      state.copyWith(bio: bio, status: EditProfileStatus.initial),
    );
  }

  void submitBioChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final updatedUser = user.copyWith(bio: state.bio);
      await _userRepository.updateUser(user: updatedUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your bio.',
            ),
          ),
        );
      }
    }
  }

  void selectedGenderChanged(String selectedGender) {
    emit(
      state.copyWith(
          selectedGender: selectedGender, status: EditProfileStatus.initial),
    );
  }

  void submitselectedGenderChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final updatedUser = user.copyWith(selectedGender: state.selectedGender);
      await _userRepository.updateUser(user: updatedUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your selectedGender.',
            ),
          ),
        );
      }
    }
  }

  void locationChanged(
      String? locationCity, String? locationState, String? locationCountry) {
    emit(
      state.copyWith(
        locationCity: locationCity,
        locationState: locationState,
        locationCountry: locationCountry,
        status: EditProfileStatus.initial,
      ),
    );
  }

  void submitLocationChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final updatedUser = user.copyWith(
        locationCity: state.locationCity,
        locationState: state.locationState,
        locationCountry: state.locationCountry,
      );
      await _userRepository.updateUser(user: updatedUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your location.',
            ),
          ),
        );
      }
    }
  }

  void locationCityChanged(String? locationCity) {
    emit(
      state.copyWith(
          locationCity: locationCity, status: EditProfileStatus.initial),
    );
  }

  void submitLocationCityChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final updatedUser = user.copyWith(locationCity: state.locationCity);
      await _userRepository.updateUser(user: updatedUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your location City.',
            ),
          ),
        );
      }
    }
  }

  void locationStateChanged(String? locationState) {
    emit(
      state.copyWith(
          locationState: locationState, status: EditProfileStatus.initial),
    );
  }

  void submitLocationStateChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final updatedUser = user.copyWith(locationState: state.locationState);
      await _userRepository.updateUser(user: updatedUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your location state.',
            ),
          ),
        );
      }
    }
  }

  void locationCountryChanged(String? locationCountry) {
    emit(
      state.copyWith(
          locationCountry: locationCountry, status: EditProfileStatus.initial),
    );
  }

  void submitLocationCountryChange() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      final updatedUser = user.copyWith(locationCountry: state.locationCountry);
      await _userRepository.updateUser(user: updatedUser);
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
      }
    } catch (err) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your location country.',
            ),
          ),
        );
      }
    }
  }

  void profileImageChanged(File image) {
    emit(
      state.copyWith(profileImage: image, status: EditProfileStatus.initial),
    );
  }

  void submitprofileImage() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    debugPrint('Submitting profile image...');

    try {
      final user = _profileBloc.state.user;

      debugPrint('Current user: ${user.id}');
      var profileImageUrl = user.profileImageUrl;
      debugPrint('Current profile image URL: $profileImageUrl');

      if (state.profileImage != null) {
        debugPrint('Profile image exists. Compressing image...');
        File compressedImage = await compressImage(state.profileImage!);
        debugPrint(
            'Image compressed. Compressed image path: ${compressedImage.path}');

        debugPrint('Uploading profile image...');
        profileImageUrl = await _storageRepository.uploadProfileImage(
          url: profileImageUrl,
          image: compressedImage,
        );

        if (profileImageUrl.isEmpty) {
          debugPrint('Error: profileImageUrl is empty after upload.');
          throw Exception('Failed to upload profile image.');
        }

        debugPrint('Profile image uploaded. New URL: $profileImageUrl');
      } else {
        debugPrint('Error: state.profileImage is null.');
        throw Exception('Profile image is null.');
      }

      final updatedUser = user.copyWith(profileImageUrl: profileImageUrl);
      debugPrint('Updating user with new profile image URL...');
      await _userRepository.updateUser(user: updatedUser);
      debugPrint('User updated successfully.');

      _profileBloc.add(ProfileLoadUser(userId: user.id));
      debugPrint('ProfileLoadUser event added to ProfileBloc.');

      if (!isClosed) {
        emit(state.copyWith(status: EditProfileStatus.success));
        debugPrint('Profile image submission successful.');
      }
    } catch (err) {
      debugPrint('Error during profile image submission: $err');
      if (!isClosed) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            failure: const Failure(
              message: 'We were unable to update your profile.',
            ),
          ),
        );
        debugPrint('Profile image submission failed.');
      }
    }
  }

  Future<File> compressImage(File imageFile, {int quality = 45}) async {
    final filePath = imageFile.absolute.path;
    final lastIndex = filePath.lastIndexOf(Platform.pathSeparator);
    final newPath = filePath.substring(0, lastIndex);
    var compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$newPath/compressed.jpg',
      quality: quality,
    );

    if (compressedImageFile == null) {
      debugPrint('Error: compressedImageFile is null.');
      throw Exception('Image compression failed.');
    }

    return File(compressedImageFile.path);
  }
}
