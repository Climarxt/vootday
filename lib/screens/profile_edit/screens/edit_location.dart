// ignore_for_file: library_private_types_in_public_api

import 'package:bootdv2/screens/profile_edit/widgets/custom_textfield.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_editprofile.dart';
import 'package:bootdv2/screens/profile_edit/cubit/edit_profile_cubit.dart';
import 'package:bootdv2/screens/profile_edit/widgets/error_dialog.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';

class EditLocationScreen extends StatefulWidget {
  final String userId;

  const EditLocationScreen({
    super.key,
    required this.userId,
  });

  @override
  _EditLocationScreenState createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

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
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState.status == ProfileStatus.loaded &&
              _locationController.text.isEmpty) {
            _locationController.text = profileState.user.location;
          }

          return Scaffold(
            appBar: const AppBarEditProfile(title: "Edit location"),
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
                        controller: _locationController,
                        labelText: 'Location',
                        onChanged: (value) {
                          context
                              .read<EditProfileCubit>()
                              .locationChanged(value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      CSCPicker(
                        onCountryChanged: (country) {
                          setState(() {
                            selectedCountry = country;
                            selectedState = null;
                            selectedCity = null;
                          });
                        },
                        onStateChanged: (state) {
                          setState(() {
                            selectedState = state;
                            selectedCity = null;
                          });
                        },
                        onCityChanged: (city) {
                          setState(() {
                            selectedCity = city;
                          });
                          context
                              .read<EditProfileCubit>()
                              .locationChanged(city);
                        },
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
        final currentlocation = selectedCity ??
            (_locationController.text.isEmpty
                ? profileState.user.location
                : _locationController.text);
        context.read<EditProfileCubit>().locationChanged(currentlocation);
        context.read<EditProfileCubit>().submitLocationChange();
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
