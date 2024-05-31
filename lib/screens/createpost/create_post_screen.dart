import 'dart:io';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/createpost/create_post_fab.dart';
import 'package:bootdv2/screens/createpost/create_post_form.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/createpost/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  void initState() {
    super.initState();
    _pickAndCropImage(context);
  }

  // Image file to be posted
  File? _postImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          return Scaffold(
            appBar: AppBarCreatePost(
              title: AppLocalizations.of(context)!.translate('addpost'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: BlocConsumer<CreatePostCubit, CreatePostState>(
              listener: (context, state) =>
                  _handleCreatePostStateChanges(context, state),
              builder: (context, state) => Column(
                children: [
                  _buildImageSection(context, state),
                  CreatePostForm(_formKey),
                ],
              ),
            ),
            floatingActionButton: CreatePostFab(_formKey, _postImage),
          );
        },
      ),
    );
  }

  // Builds the image section of the form
  Widget _buildImageSection(BuildContext context, CreatePostState state) {
    double reducedHeight = MediaQuery.of(context).size.height * 0.3 * 0.8;
    double reducedWidth = reducedHeight * 0.7; // Maintain aspect ratio

    return GestureDetector(
      onTap: () async => _pickAndCropImage(context),
      child: Center(
        child: SizedBox(
          height: reducedHeight,
          width: reducedWidth,
          child: CreatePostCard(postImage: state.postImage),
        ),
      ),
    );
  }

  Future<void> _pickAndCropImage(BuildContext context) async {
    final file = await ImageHelperPost().pickImage();
    if (file != null) {
      final croppedFile = await ImageHelperPost().crop(
        file: file,
        cropStyle: CropStyle.rectangle,
      );
      if (croppedFile != null) {
        setState(() {
          _postImage = File(croppedFile.path);
          context.read<CreatePostCubit>().postImageChanged(_postImage!);
        });
      }
    }
  }

  void _handleCreatePostStateChanges(
      BuildContext context, CreatePostState state) {
    if (state.status == CreatePostStatus.success) {
      _resetForm(context);
      SnackbarUtil.showSuccessSnackbar(context, 'Post Created!');
      GoRouter.of(context).go('/profile');
    } else if (state.status == CreatePostStatus.error) {
      SnackbarUtil.showErrorSnackbar(context, state.failure.message);
    }
  }

  void _resetForm(BuildContext context) {
    _formKey.currentState!.reset();
    context.read<CreatePostCubit>().reset();
  }
}
