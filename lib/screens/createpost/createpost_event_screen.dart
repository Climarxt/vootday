import 'dart:io';

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/createpost/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostEventScreen extends StatefulWidget {
  final String eventId;

  const CreatePostEventScreen({super.key, required this.eventId});

  @override
  State<CreatePostEventScreen> createState() => _CreatePostEventScreenState();
}

class _CreatePostEventScreenState extends State<CreatePostEventScreen> {
  File? _postImage;
  final imageHelper = ImageHelperPost();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarCreateEventPost(
          title: AppLocalizations.of(context)!.translate('addpost'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) =>
              _handleCreatePostStateChanges(context, state),
          builder: (context, state) => Stack(
            children: [
              Column(
                children: [
                  _buildImageSection(context, state),
                  _buildForm(context, state),
                ],
              ),
              if (state.status == CreatePostStatus.submitting) ...[
                const ModalBarrier(
                  dismissible: false,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  // Builds the form
  Widget _buildForm(BuildContext context, CreatePostState state) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(
                context,
                AppLocalizations.of(context)!.translate('description'),
                state.caption,
                navigateToEditCaption,
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildField(BuildContext context, String label, String value,
      Function(BuildContext) navigateFunction) {
    return Bounceable(
      onTap: () {
        navigateFunction(context);
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style: AppTextStyles.titleLargeBlackBold(context),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value.isEmpty
                              ? '${AppLocalizations.of(context)!.translate('add')} ${label.toLowerCase()}'
                              : value,
                          style: value.isEmpty
                              ? AppTextStyles.bodyStyleGrey(context)
                              : AppTextStyles.bodyStyle(context),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: black, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToEditCaption(BuildContext context) {
    GoRouter.of(context).go(
      '/calendar/event/${widget.eventId}/create/editcaption',
      extra: {
        'cubit': context.read<CreatePostCubit>(),
        'eventId': widget.eventId,
      },
    );
  }

  // Submits the form
  void _submitForm(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (_formKey.currentState!.validate() && _postImage != null) {
      final eventId = widget.eventId;
      context.read<CreatePostCubit>().submitPostEvent(eventId);
    }
  }

  // Builds the image section of the form
  Widget _buildImageSection(BuildContext context, CreatePostState state) {
    double enlargedHeight = MediaQuery.of(context).size.height * 0.4;
    double enlargedWidth = enlargedHeight * 0.7; // Maintain aspect ratio

    return GestureDetector(
      onTap: () async => _pickAndCropImage(context),
      child: Center(
        child: SizedBox(
          height: enlargedHeight,
          width: enlargedWidth,
          child: _postImage != null
              ? Image.file(_postImage!)
              : CreatePostCard(postImage: state.postImage),
        ),
      ),
    );
  }

  // Picks and crops the image
  Future<void> _pickAndCropImage(BuildContext context) async {
    if (_isPickingImage) return; // Prevent multiple requests
    setState(() {
      _isPickingImage = true;
    });

    try {
      final file = await imageHelper.pickImage();
      if (file != null) {
        final croppedFile = await imageHelper.crop(
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
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  // Handles different state changes
  void _handleCreatePostStateChanges(
      BuildContext context, CreatePostState state) {
    if (state.status == CreatePostStatus.success) {
      // Reset form and show success message
      _resetForm(context);
      SnackbarUtil.showSuccessSnackbar(context, 'Post Created !');

      // Navigate to the calendar route
      GoRouter.of(context).go('/calendar');
    } else if (state.status == CreatePostStatus.error) {
      // Show error message
      SnackbarUtil.showErrorSnackbar(context, state.failure.message);
    }
  }

  // Resets the form
  void _resetForm(BuildContext context) {
    _formKey.currentState!.reset();
    context.read<CreatePostCubit>().reset();
  }
}
