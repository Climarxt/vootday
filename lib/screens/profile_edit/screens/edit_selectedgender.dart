import 'package:bootdv2/restart_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_editprofile.dart';
import 'package:bootdv2/screens/profile_edit/cubit/edit_profile_cubit.dart';
import 'package:bootdv2/screens/profile_edit/widgets/error_dialog.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';

class EditSelectedGenderScreen extends StatefulWidget {
  final String userId;

  const EditSelectedGenderScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _EditSelectedGenderScreenState createState() =>
      _EditSelectedGenderScreenState();
}

class _EditSelectedGenderScreenState extends State<EditSelectedGenderScreen> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileBloc>().add(ProfileLoadUser(userId: widget.userId));
      }
    });
  }

  Widget _buildGenderDropdown(BuildContext context, String? selectedGender) {
    return Column(
      children: [
        DropdownButtonFormField(
          decoration: const InputDecoration(
            hintText: 'Genre',
            labelText: 'Choisir un genre',
            hintStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(color: Colors.black),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          value: selectedGender,
          items: const [
            DropdownMenuItem(
              value: 'Masculin',
              child: Text("Masculin"),
            ),
            DropdownMenuItem(
              value: 'Féminin',
              child: Text("Féminin"),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
            context.read<EditProfileCubit>().selectedGenderChanged(value!);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState.status == ProfileStatus.loaded &&
              _selectedGender == null) {
            _selectedGender = profileState.user.selectedGender;
          }

          return Scaffold(
            appBar: const AppBarEditProfile(title: "Edit Gender"),
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
                      _buildGenderDropdown(context, _selectedGender),
                      const SizedBox(height: 16.0),
                      Text(
                        "Sélectionnez le genre qui vous intéresse.",
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
        final currentSelectedGender =
            _selectedGender ?? profileState.user.selectedGender;
        context
            .read<EditProfileCubit>()
            .selectedGenderChanged(currentSelectedGender);
        context.read<EditProfileCubit>().submitselectedGenderChange();

        // Redémarrer l'application après le changement de genre
        RestartWidget.restartApp(context);
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
