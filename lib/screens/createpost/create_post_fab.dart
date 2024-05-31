import 'dart:io';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/createpost/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostFab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final File? postImage;

  const CreatePostFab(this.formKey, this.postImage, {super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreatePostCubit>().state;
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: state.status != CreatePostStatus.submitting
          ? () => _submitForm(context)
          : null,
      label: Text(AppLocalizations.of(context)!.translate('add'),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white)),
    );
  }

  void _submitForm(BuildContext context) {
    if (formKey.currentState!.validate() && postImage != null) {
      context.read<CreatePostCubit>().submit();
    } else {
      SnackbarUtil.showErrorSnackbar(context, 'Please select an image.');
    }
  }
}
