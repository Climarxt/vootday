import 'dart:io';

import 'package:bootdv2/config/colors.dart';
import 'package:bootdv2/config/localizations.dart';
import 'package:bootdv2/widgets/cards/create_post_card.dart';
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
    _pickAndCropImage(context);
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) =>
              _handleCreatePostStateChanges(context, state),
          builder: (context, state) => _buildForm(context, state),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSection(context, state),
            if (state.status == CreatePostStatus.submitting)
              const LinearProgressIndicator(),
            _buildCaptionInputAndButtons(context, state),
            _buildChipInputSection(context, state),
          ],
        ),
      ),
    );
  }

  // Builds the image section of the form
  Widget _buildImageSection(BuildContext context, CreatePostState state) {
    double reducedHeight =
        MediaQuery.of(context).size.height * 0.6 * 0.8; // Reduce by 20%
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

  // New chip input section
  Widget _buildChipInputSection(BuildContext context, CreatePostState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tags:'),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: state.tags.map((tag) {
              return Chip(
                label: Text(tag),
                onDeleted: () {
                  context.read<CreatePostCubit>().removeTag(tag);
                },
              );
            }).toList(),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Add a tag',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  final tag = _tagController.text;
                  if (tag.isNotEmpty) {
                    context.read<CreatePostCubit>().addTag(tag);
                    _tagController.clear();
                  }
                },
              ),
            ),
            controller: _tagController,
            onFieldSubmitted: (tag) {
              if (tag.isNotEmpty) {
                context.read<CreatePostCubit>().addTag(tag);
                _tagController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  final TextEditingController _tagController = TextEditingController();

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
            const SizedBox(height: 20),
            //_buildResetButton(context),
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
  Widget _buildFloatingActionButton(BuildContext context) {
    final state = context.watch<CreatePostCubit>().state;
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: state.status != CreatePostStatus.submitting
          ? () => _submitForm(context)
          : null,
      label: Text(AppLocalizations.of(context)!.translate('add'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white)),
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
