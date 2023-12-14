part of 'update_public_status_cubit.dart';

abstract class UpdatePublicStatusState {}

class UpdatePublicStatusInitial extends UpdatePublicStatusState {}

class UpdatePublicStatusLoading extends UpdatePublicStatusState {}

class UpdatePublicStatusSuccess extends UpdatePublicStatusState {}

class UpdatePublicStatusError extends UpdatePublicStatusState {
  final String message;

  UpdatePublicStatusError(this.message);
}
