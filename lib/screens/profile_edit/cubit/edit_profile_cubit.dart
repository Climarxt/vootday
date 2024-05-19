import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:equatable/equatable.dart';
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

  Future<File> compressImage(File imageFile, {int quality = 45}) async {
    final filePath = imageFile.absolute.path;
    final lastIndex = filePath.lastIndexOf(Platform.pathSeparator);
    final newPath = filePath.substring(0, lastIndex);
    var compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$newPath/compressed.jpg',
      quality: quality,
    );

    if (compressedImageFile is XFile) {
      return File(compressedImageFile.path);
    } else {
      // ignore: null_check_always_fails
      return compressedImageFile!;
    }
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

  void profileImageChanged(File image) {
    emit(
      state.copyWith(profileImage: image, status: EditProfileStatus.initial),
    );
  }

  void submitprofileImage() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      var profileImageUrl = user.profileImageUrl;
      if (state.profileImage != null) {
        File compressedImage = await compressImage(state.profileImage!);
        profileImageUrl = await _storageRepository.uploadProfileImage(
          url: profileImageUrl,
          image: compressedImage,
        );
      }
      final updatedUser = user.copyWith(profileImageUrl: profileImageUrl);
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
              message: 'We were unable to update your profile.',
            ),
          ),
        );
      }
    }
  }
}
