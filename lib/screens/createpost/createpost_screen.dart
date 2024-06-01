import 'dart:io';

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/createpost/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _postImage;
  final imageHelper = ImageHelperPost();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pickAndCropImage(context);
  }

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
              builder: (context, state) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        _buildImageSection(context, state),
                        _buildForm(context, state, profileState),
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
                );
              },
            ),
            floatingActionButton: _buildFloatingActionButton(context),
          );
        },
      ),
    );
  }

// Builds the form
  Widget _buildForm(
      BuildContext context, CreatePostState state, ProfileState profileState) {
    String tagsAsString = state.tags.join(', ');
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField(
                context,
                AppLocalizations.of(context)!.translate('brand'),
                tagsAsString,
                navigateToEditBrand,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                AppLocalizations.of(context)!.translate('location'),
                state.locationSelected,
                navigateToEditLocation,
              ),
              const SizedBox(height: 12),
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
                          value.isEmpty ? 'Add ${label.toLowerCase()}' : value,
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
          child: _postImage != null
              ? Image.file(_postImage!)
              : CreatePostCard(postImage: state.postImage),
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
          context.read<CreatePostCubit>().postImageChanged(_postImage!);
        });
      }
    }
  }

  // Submits the form
  void _submitForm(BuildContext context) {
    final state = context.read<CreatePostCubit>().state;

    if (_formKey.currentState!.validate()) {
      if (_postImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.translate('imagenotempty'),
            ),
          ),
        );
        return;
      }
      if (state.locationSelected.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.translate('locationnotempty'),
            ),
          ),
        );
        return;
      }
      context.read<CreatePostCubit>().submit();
    }
  }

  // Navigates to the 'Edit Location' screen.
  void navigateToEditLocation(BuildContext context) {
    GoRouter.of(context).go(
      '/profile/create/editlocation',
      extra: context.read<CreatePostCubit>(),
    );
  }

  // Navigates to the 'Edit Caption' screen.
  void navigateToEditCaption(BuildContext context) {
    GoRouter.of(context).go('/profile/create/editcaption',
        extra: {'cubit': context.read<CreatePostCubit>()});
  }

  // Navigates to the 'Edit Brand' screen.
  void navigateToEditBrand(BuildContext context) {
    GoRouter.of(context)
        .go('/profile/create/brand', extra: context.read<CreatePostCubit>());
  }

  // Handles different state changes
  void _handleCreatePostStateChanges(
      BuildContext context, CreatePostState state) {
    if (state.status == CreatePostStatus.success) {
      _resetForm(context);
      SnackbarUtil.showSuccessSnackbar(context, 'Post Created !');
      GoRouter.of(context).go('/profile');
    } else if (state.status == CreatePostStatus.error) {
      SnackbarUtil.showErrorSnackbar(context, state.failure.message);
    }
  }

  // Resets the form
  void _resetForm(BuildContext context) {
    _formKey.currentState!.reset();
    context.read<CreatePostCubit>().reset();
  }
}
