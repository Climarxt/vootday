// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_editprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/widgets/widgets.dart';
import 'cubit/edit_profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _image;
  final ImageHelperProfile imageHelper = ImageHelperProfile();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(ProfileLoadUser(userId: widget.userId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          return Scaffold(
            appBar: AppBarEditProfile(
              title: AppLocalizations.of(context)!.translate('editProfile'),
            ),
            body: BlocConsumer<EditProfileCubit, EditProfileState>(
              listener: (context, state) {
                if (state.status == EditProfileStatus.success) {
                  Navigator.of(context).pop();
                } else if (state.status == EditProfileStatus.error) {
                  ErrorDialog(content: state.failure.message);
                }
              },
              builder: (context, editState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      if (editState.status == EditProfileStatus.submitting)
                        const LinearProgressIndicator(),
                      Column(
                        children: [
                          _buildProfileImage(context, profileState, editState),
                        ],
                      ),
                      _buildForm(context, profileState, editState),
                    ],
                  ),
                );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                _buildFloatingValidateButton(context, profileState),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, ProfileState profileState,
      EditProfileState editState) {
    return GestureDetector(
      onTap: () async {
        final file = await imageHelper.pickImage();
        if (file != null) {
          final croppedFile =
              await imageHelper.crop(file: file, cropStyle: CropStyle.circle);
          if (croppedFile != null) {
            setState(() {
              _image = File(croppedFile.path);
            });
            if (mounted) {
              context.read<EditProfileCubit>().profileImageChanged(_image!);
            }
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          UserProfileImage(
            radius: 80.0,
            outerCircleRadius: 81,
            profileImageUrl: profileState.user.profileImageUrl,
            profileImage: editState.profileImage,
          ),
          Icon(
            Icons.edit,
            color: Colors.white.withOpacity(0.6),
            size: 30.0,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, ProfileState profileState,
      EditProfileState editState) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(
                context,
                AppLocalizations.of(context)!.translate('username'),
                profileState.user.username,
                navigateToEditUsername),
            const SizedBox(height: 12),
            _buildField(
                context,
                AppLocalizations.of(context)!.translate('firstName'),
                profileState.user.firstName,
                navigateToEditfirstName),
            const SizedBox(height: 12),
            _buildField(
                context,
                AppLocalizations.of(context)!.translate('lastName'),
                profileState.user.lastName,
                navigateToEditLastName),
            const SizedBox(height: 12),
            _buildField(
                context,
                AppLocalizations.of(context)!.translate('location'),
                profileState.user.locationCity,
                navigateToEditLocation),
            const SizedBox(height: 12),
            _buildField(
                context,
                AppLocalizations.of(context)!.translate('interestedIn'),
                profileState.user.selectedGender,
                navigateToEditInterestedIn),
            const SizedBox(height: 12),
            _buildField(
                context, 'Bio', profileState.user.bio, navigateToEditBio),
            const SizedBox(height: 12),
            _buildField(
                context,
                AppLocalizations.of(context)!.translate('links'),
                AppLocalizations.of(context)!.translate('socialNetworks'),
                navigateToEditLinks),
          ],
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

  Widget _buildFloatingValidateButton(
      BuildContext context, ProfileState profileState) {
    return _image != null
        ? FloatingActionButton.extended(
            backgroundColor: couleurBleuClair2,
            onPressed: () {
              context.read<EditProfileCubit>().submitprofileImage();
            },
            label: Text(
              AppLocalizations.of(context)!.translate('validate'),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            ),
          )
        : SizedBox.shrink();
  }

  // Navigates to the 'Edit Username' screen.
  void navigateToEditUsername(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editusername');
  }

  // Navigates to the 'Edit Firstname' screen.
  void navigateToEditfirstName(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editfirstname');
  }

  // Navigates to the 'Edit Lastname' screen.
  void navigateToEditLastName(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editlastname');
  }

  // Navigates to the 'Edit Location' screen.
  void navigateToEditLocation(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editlocation');
  }

  // Navigates to the 'Edit Interested In' screen.
  void navigateToEditInterestedIn(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editselectedgender');
  }

  // Navigates to the 'Edit Bio' screen.
  void navigateToEditBio(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editbio');
  }

  // Navigates to the 'Edit Links' screen.
  void navigateToEditLinks(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editlinks');
  }
}
