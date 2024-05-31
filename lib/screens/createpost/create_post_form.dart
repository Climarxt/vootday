import 'dart:io';

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/createpost/create_post_brand_input.dart';
import 'package:bootdv2/screens/createpost/create_post_caption_input.dart';
import 'package:bootdv2/screens/createpost/create_post_field.dart';
import 'package:bootdv2/screens/createpost/create_post_image_section.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePostForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final File postImage;

  const CreatePostForm(this.formKey, this.postImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CreatePostImageSection(postImage: postImage),
          if (context.watch<CreatePostCubit>().state.status ==
              CreatePostStatus.submitting)
            const LinearProgressIndicator(),
          CreatePostCaptionInput(formKey),
          const CreatePostBrandInput(),
          CreatePostField(
            context,
            AppLocalizations.of(context)!.translate('location'),
            context.watch<CreatePostCubit>().state.locationSelected,
            navigateToEditLocation,
          ),
        ],
      ),
    );
  }

  void navigateToEditLocation(BuildContext context) {
    GoRouter.of(context).go('/profile/create/editlocation',
        extra: context.read<CreatePostCubit>());
  }
}
