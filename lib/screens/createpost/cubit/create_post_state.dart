part of 'create_post_cubit.dart';

enum CreatePostStatus { initial, submitting, success, error }

class CreatePostState extends Equatable {
  final File? postImage;
  final String caption;
  final List<String> tags;
  final CreatePostStatus status;
  final Failure failure;
  final String selectedGender;
  final String locationCity;
  final String locationState;
  final String locationCountry;
  final String locationSelected;

  const CreatePostState({
    required this.postImage,
    required this.caption,
    required this.tags,
    required this.status,
    required this.failure,
    required this.selectedGender,
    required this.locationCity,
    required this.locationState,
    required this.locationCountry,
    required this.locationSelected,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      postImage: null,
      caption: '',
      tags: [],
      status: CreatePostStatus.initial,
      failure: Failure(),
      selectedGender: '',
      locationCity: '',
      locationState: '',
      locationCountry: '',
      locationSelected: '',
    );
  }

  @override
  List<Object?> get props => [
        postImage,
        caption,
        tags,
        status,
        failure,
        selectedGender,
        locationCity,
        locationState,
        locationCountry,
        locationSelected,
      ];

  CreatePostState copyWith({
    File? postImage,
    String? caption,
    List<String>? tags,
    CreatePostStatus? status,
    Failure? failure,
    String? selectedGender,
    String? locationCity,
    String? locationState,
    String? locationCountry,
    String? locationSelected,
  }) {
    return CreatePostState(
      postImage: postImage ?? this.postImage,
      caption: caption ?? this.caption,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      selectedGender: selectedGender ?? this.selectedGender,
      locationCity: locationCity ?? this.locationCity,
      locationState: locationState ?? this.locationState,
      locationCountry: locationCountry ?? this.locationCountry,
      locationSelected: locationSelected ?? this.locationSelected,
    );
  }
}
