part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  final File? profileImage;
  final String username;
  final String firstName;
  final String lastName;
  final String bio;
  final String selectedGender;
  final String location;
  final EditProfileStatus status;
  final Failure failure;

  const EditProfileState({
    required this.profileImage,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.selectedGender,
    required this.location,
    required this.status,
    required this.failure,
  });

  factory EditProfileState.initial() {
    return const EditProfileState(
      profileImage: null,
      username: '',
      firstName: '',
      lastName: '',
      bio: '',
      selectedGender: '',
      location: '',
      status: EditProfileStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [
        profileImage,
        username,
        firstName,
        lastName,
        bio,
        selectedGender,
        location,
        status,
        failure,
      ];

  EditProfileState copyWith({
    File? profileImage,
    String? username,
    String? firstName,
    String? lastName,
    String? bio,
    String? selectedGender,
    String? location,
    EditProfileStatus? status,
    Failure? failure,
  }) {
    return EditProfileState(
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      selectedGender: selectedGender ?? this.selectedGender,
      location: location ?? this.location,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
