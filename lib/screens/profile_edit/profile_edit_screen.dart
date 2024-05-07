import 'dart:io';

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_profile.dart';
import 'package:bootdv2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/edit_profile_cubit.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  EditProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _image;
  final imageHelper = ImageHelperProfile();

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
      child: Scaffold(
        appBar: const AppBarProfile(title: "Edit Profile"),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, editState) {
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      if (editState.status == EditProfileStatus.submitting)
                        const LinearProgressIndicator(),
                      const SizedBox(height: 32.0),
                      GestureDetector(
                        onTap: () async {
                          final file = await imageHelper.pickImage();
                          if (file != null) {
                            final croppedFile = await imageHelper.crop(
                              file: file,
                              cropStyle: CropStyle.circle,
                            );
                            if (croppedFile != null) {
                              setState(() {
                                _image = File(croppedFile.path);
                                context
                                    .read<EditProfileCubit>()
                                    .profileImageChanged(_image!);
                              });
                            }
                          }
                        },
                        child: UserProfileImage(
                          radius: 80.0,
                          outerCircleRadius: 81,
                          profileImageUrl:
                              profileState.user.profileImageUrl, // Mis à jour
                          profileImage: editState.profileImage,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                initialValue:
                                    profileState.user.username, // Mis à jour
                                decoration: InputDecoration(
                                    hintText: profileState.user.username),
                                onChanged: (value) => context
                                    .read<EditProfileCubit>()
                                    .usernameChanged(value),
                                validator: (value) => value!.trim().isEmpty
                                    ? 'Username cannot be empty.'
                                    : null,
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                initialValue: profileState.user.bio,
                                decoration:
                                    const InputDecoration(hintText: 'Bio'),
                                onChanged: (value) => context
                                    .read<EditProfileCubit>()
                                    .bioChanged(value),
                                validator: (value) => value!.trim().isEmpty
                                    ? 'Bio cannot be empty.'
                                    : null,
                              ),
                              const SizedBox(height: 28.0),
                              buildButton(context, editState),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // void _selectProfileImage(BuildContext context) async {
  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }

  TextButton buildButton(BuildContext context, EditProfileState editState) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: couleurBleuClair2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => _submitForm(
        context,
        editState.status == EditProfileStatus.submitting,
      ),
      child: Text(
        AppLocalizations.of(context)!.translate('editProfile'),
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
      ),
    );
  }
}
