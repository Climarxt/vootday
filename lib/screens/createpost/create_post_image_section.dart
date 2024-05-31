import 'dart:io';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/createpost/utils/image_helpder.dart';
import 'package:bootdv2/screens/createpost/widgets/create_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostImageSection extends StatelessWidget {
  final File postImage;

  const CreatePostImageSection({required this.postImage, super.key});

  @override
  Widget build(BuildContext context) {
    double reducedHeight = MediaQuery.of(context).size.height * 0.3 * 0.8;
    double reducedWidth = reducedHeight * 0.7; // Maintain aspect ratio

    return GestureDetector(
      onTap: () async => _pickAndCropImage(context),
      child: Center(
        child: SizedBox(
          height: reducedHeight,
          width: reducedWidth,
          child: CreatePostCard(postImage: context.watch<CreatePostCubit>().state.postImage),
        ),
      ),
    );
  }

  Future<void> _pickAndCropImage(BuildContext context) async {
    final file = await ImageHelperPost().pickImage();
    if (file != null) {
      final croppedFile = await ImageHelperPost().crop(file: file, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        context.read<CreatePostCubit>().postImageChanged(File(croppedFile.path));
      }
    }
  }
}
