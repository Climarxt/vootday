part of 'create_post_cubit.dart';

enum CreatePostStatus { initial, submitting, success, error }

class CreatePostState extends Equatable {
  final File? postImage;
  final String caption;
  final List<String> tags; // New tags property
  final CreatePostStatus status;
  final Failure failure;
  final String selectedGender;

  const CreatePostState({
    required this.postImage,
    required this.caption,
    required this.tags, // Required tags property in the constructor
    required this.status,
    required this.failure,
    required this.selectedGender,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      postImage: null,
      caption: '',
      tags: [], // Initialized as empty
      status: CreatePostStatus.initial,
      failure: Failure(),
      selectedGender: '',
    );
  }

  @override
  List<Object?> get props => [
        postImage,
        caption,
        tags, // Add tags to props for Equatable
        status,
        failure,
        selectedGender,
      ];

  CreatePostState copyWith({
    File? postImage,
    String? caption,
    List<String>? tags, // New tags property for copyWith method
    CreatePostStatus? status,
    Failure? failure,
    String? selectedGender,
  }) {
    return CreatePostState(
      postImage: postImage ?? this.postImage,
      caption: caption ?? this.caption,
      tags: tags ?? this.tags, // Use tags in copyWith
      status: status ?? this.status,
      failure: failure ?? this.failure,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }
}
