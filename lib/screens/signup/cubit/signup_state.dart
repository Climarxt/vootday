part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String selectedGender;
  final SignupStatus status;
  final Failure failure;

  bool get isFormValid =>
      username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;

  const SignupState({
    required this.username,
    required this.email,
    required this.password,
    required this.selectedGender,
    required this.status,
    required this.failure,
  });

  factory SignupState.initial() {
    return const SignupState(
      username: '',
      email: '',
      password: '',
      selectedGender: '',
      status: SignupStatus.initial,
      failure: Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [username, email, password,selectedGender, status, failure];

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    String? selectedGender,
    SignupStatus? status,
    Failure? failure,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      selectedGender: selectedGender ?? this.selectedGender,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
