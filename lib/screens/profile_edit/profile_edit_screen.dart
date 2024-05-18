import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_profile.dart';
import 'package:bootdv2/widgets/widgets.dart';
import 'cubit/edit_profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

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
      child: Scaffold(
        appBar: const AppBarProfile(title: "Edit Profile"),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              _showErrorDialog(context, state.failure.message);
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
                      _buildProfileImage(context, profileState, editState),
                      _buildForm(context, profileState, editState),
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
              context.read<EditProfileCubit>().profileImageChanged(_image!);
            });
          }
        }
      },
      child: UserProfileImage(
        radius: 80.0,
        outerCircleRadius: 81,
        profileImageUrl: profileState.user.profileImageUrl,
        profileImage: editState.profileImage,
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
            _buildField(context, 'Username', profileState.user.username,
                EditUsernamePage(userId: widget.userId)),
            const SizedBox(height: 16.0),
            _buildField(context, 'FirstName', profileState.user.firstName,
                EditNamePage(userId: widget.userId)),
            const SizedBox(height: 16.0),
            _buildField(context, 'Bio', profileState.user.bio,
                EditBioPage(userId: widget.userId)),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      BuildContext context, String label, String value, Widget editPage) {
    return Bounceable(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => editPage,
        ));
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                          style: AppTextStyles.bodyStyle(context),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: black, size: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, EditProfileState editState) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: couleurBleuClair2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => _submitForm(
          context, editState.status == EditProfileStatus.submitting),
      child: Text(
        AppLocalizations.of(context)!.translate('editProfile'),
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.white),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(content: message),
    );
  }
}

class EditUsernamePage extends StatelessWidget {
  final String userId;

  const EditUsernamePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Username")),
      body: Center(
        child: Text("Edit Username Page for user $userId"),
      ),
    );
  }
}

class EditNamePage extends StatelessWidget {
  final String userId;

  const EditNamePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Name")),
      body: Center(
        child: Text("Edit Name Page for user $userId"),
      ),
    );
  }
}

class EditBioPage extends StatelessWidget {
  final String userId;

  const EditBioPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Bio")),
      body: Center(
        child: Text("Edit Bio Page for user $userId"),
      ),
    );
  }
}
