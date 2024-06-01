// ignore_for_file: unused_field

import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/createpost/widgets/widgets.dart';
import 'package:bootdv2/screens/profile_edit/widgets/custom_textfield_caption.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_editprofile.dart';
import 'package:go_router/go_router.dart';

class EditCaptionCreatePostScreen extends StatefulWidget {
  final String userId;

  const EditCaptionCreatePostScreen({
    super.key,
    required this.userId,
  });

  @override
  _EditLocationCreatePostScreenState createState() =>
      _EditLocationCreatePostScreenState();
}

class _EditLocationCreatePostScreenState
    extends State<EditCaptionCreatePostScreen> {
  final TextEditingController _locationController = TextEditingController();
  String? _selectedLocationType;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarEditProfile(
          title: AppLocalizations.of(context)!.translate('editDescription'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) =>
              _handleCreatePostStateChanges(context, state),
          builder: (context, editState) {
            _captionController.text = editState.caption;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFieldCaption(
                    controller: _captionController,
                    labelText:
                        AppLocalizations.of(context)!.translate('description'),
                    onChanged: (value) {
                      context.read<CreatePostCubit>().captionChanged(value);
                      setState(() {
                        context.read<CreatePostCubit>().captionChanged(value);
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            );
          },
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _handleCreatePostStateChanges(
      BuildContext context, CreatePostState state) {
    if (state.status == CreatePostStatus.success) {
      SnackbarUtil.showSuccessSnackbar(context, 'Post Created !');
      GoRouter.of(context).go('/profile');
    } else if (state.status == CreatePostStatus.error) {
      SnackbarUtil.showErrorSnackbar(context, state.failure.message);
    }
  }

  // Builds the floating action button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () => _handlePostButtonPressed(context),
      label: Text(
        AppLocalizations.of(context)!.translate('validate'),
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white),
      ),
    );
  }

  // Handling the click of the floating action button
  void _handlePostButtonPressed(BuildContext context) {
    final goRouter = GoRouter.of(context);
    goRouter.go('/profile/create');
  }
}
