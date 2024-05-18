import 'package:bootdv2/screens/profile_edit/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_editprofile.dart';
import 'package:bootdv2/screens/profile_edit/cubit/edit_profile_cubit.dart';
import 'package:bootdv2/screens/profile_edit/widgets/error_dialog.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';

class EditLastnameScreen extends StatefulWidget {
  final String userId;

  const EditLastnameScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _EditLastnameScreenState createState() => _EditLastnameScreenState();
}

class _EditLastnameScreenState extends State<EditLastnameScreen> {
  final TextEditingController _lastnameController = TextEditingController();

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
  void dispose() {
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState.status == ProfileStatus.loaded &&
              _lastnameController.text.isEmpty) {
            _lastnameController.text = profileState.user.lastName;
          }

          return Scaffold(
            appBar: const AppBarEditProfile(title: "Edit lastname"),
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
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _lastnameController,
                        labelText: 'Lastname',
                        onChanged: (value) {
                          context
                              .read<EditProfileCubit>()
                              .lastnameChanged(value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Aidez les gens à trouver votre compte à l'aide de votre prénom.",
                        style: AppTextStyles.bodySmallStyleGrey(context),
                      ),
                      const SizedBox(height: 16.0),
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

  Widget _buildFloatingValidateButton(
      BuildContext context, ProfileState profileState) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () {
        final currentlastname = _lastnameController.text.isEmpty
            ? profileState.user.lastName
            : _lastnameController.text;
        context.read<EditProfileCubit>().lastnameChanged(currentlastname);
        context.read<EditProfileCubit>().submitLastNameChange();
      },
      label: Text(
        AppLocalizations.of(context)!.translate('validate'),
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
