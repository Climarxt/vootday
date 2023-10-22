import 'dart:io';

import 'package:bootdv2/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

import 'widgets/widgets.dart';
import '../../helpers/helpers.dart';
import 'cubit/create_post_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/createPost';

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<CreatePostCubit>();
    print("Accessed CreatePostCubit: $cubit");
  }

  // Image file to be posted
  late File _postImage;

  // Helper for image operations
  final imageHelper = ImageHelperPost();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) =>
              _handleCreatePostStateChanges(context, state),
          builder: (context, state) => _buildForm(context, state),
        ),
      ),
    );
  }

  // Handles different state changes
  void _handleCreatePostStateChanges(
      BuildContext context, CreatePostState state) {
    if (state.status == CreatePostStatus.success) {
      _resetForm(context);
      SnackbarUtil.showSuccessSnackbar(context, 'Post Created !');
    } else if (state.status == CreatePostStatus.error) {
      SnackbarUtil.showErrorSnackbar(context, state.failure.message);
    }
  }

  // Resets the form
  void _resetForm(BuildContext context) {
    _formKey.currentState!.reset();
    context.read<CreatePostCubit>().reset();
  }

  // Builds the form
  Widget _buildForm(BuildContext context, CreatePostState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImageSection(context, state),
          if (state.status == CreatePostStatus.submitting)
            const LinearProgressIndicator(),
          _buildCaptionInputAndButtons(context, state),
        ],
      ),
    );
  }

  // Builds the image section of the form
  Widget _buildImageSection(BuildContext context, CreatePostState state) {
    return GestureDetector(
      onTap: () async => _pickAndCropImage(context),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.3,
        width: double.infinity,
        color: Colors.grey[200],
        child: state.postImage != null
            ? Image.file(state.postImage!, fit: BoxFit.cover)
            : const Icon(
                Icons.image,
                color: Colors.grey,
                size: 120.0,
              ),
      ),
    );
  }

  // Picks and crops the image
  Future<void> _pickAndCropImage(BuildContext context) async {
    final file = await imageHelper.pickImage();
    if (file != null) {
      final croppedFile = await imageHelper.crop(
        file: file,
        cropStyle: CropStyle.rectangle,
      );
      if (croppedFile != null) {
        setState(() {
          _postImage = File(croppedFile.path);
          context.read<CreatePostCubit>().postImageChanged(_postImage);
        });
      }
    }
  }

  // Builds the caption input and buttons
  Widget _buildCaptionInputAndButtons(
      BuildContext context, CreatePostState state) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCaptionInput(context),
            const SizedBox(height: 10.0),
            _buildPostButton(context, state),
            const SizedBox(height: 20),
            _buildResetButton(context),
          ],
        ),
      ),
    );
  }

  // Builds the caption input field
  Widget _buildCaptionInput(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Caption'),
      onChanged: (value) =>
          context.read<CreatePostCubit>().captionChanged(value),
      validator: (value) =>
          value!.trim().isEmpty ? 'Caption cannot be empty' : null,
    );
  }

  // Builds the post button
  Widget _buildPostButton(BuildContext context, CreatePostState state) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        textStyle: const TextStyle(color: Colors.white),
      ),
      onPressed: state.status != CreatePostStatus.submitting
          ? () => _submitForm(context)
          : null,
      child: const Text('Post'),
    );
  }

  // Builds the reset button
  Widget _buildResetButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: grey,
        textStyle: const TextStyle(color: Colors.white),
      ),
      onPressed: () => _resetForm(context),
      child: const Text('Reset'),
    );
  }

  // Submits the form
  void _submitForm(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (_formKey.currentState!.validate() && _postImage != null) {
      context.read<CreatePostCubit>().submit();
    }
  }
}
