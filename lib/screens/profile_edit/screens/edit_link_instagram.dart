// ignore_for_file: library_private_types_in_public_api

import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_links.dart';
import 'package:bootdv2/screens/profile_edit/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile_edit/cubit/edit_profile_cubit.dart';
import 'package:bootdv2/screens/profile_edit/widgets/error_dialog.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:url_launcher/url_launcher.dart';

class EditLinkInstagramScreen extends StatefulWidget {
  final String userId;

  const EditLinkInstagramScreen({
    super.key,
    required this.userId,
  });

  @override
  _EditLinkInstagramScreenState createState() =>
      _EditLinkInstagramScreenState();
}

class _EditLinkInstagramScreenState extends State<EditLinkInstagramScreen> {
  final TextEditingController _socialInstagramController =
      TextEditingController();

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
    _socialInstagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState.status == ProfileStatus.loaded &&
              _socialInstagramController.text.isEmpty) {
            _socialInstagramController.text = profileState.user.socialInstagram;
          }

          return Scaffold(
            appBar: const AppBarLinks(title: "Instagram"),
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
                        controller: _socialInstagramController,
                        labelText: 'Instagram',
                        onChanged: (value) {
                          context
                              .read<EditProfileCubit>()
                              .socialInstagramChanged(value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        AppLocalizations.of(context)!
                            .translate('redirectToInstagram'),
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
        final currentsocialInstagram = _socialInstagramController.text.isEmpty
            ? profileState.user.socialInstagram
            : _socialInstagramController.text;
        context
            .read<EditProfileCubit>()
            .socialInstagramChanged(currentsocialInstagram);
        context.read<EditProfileCubit>().submitSocialInstagramChange();
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

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
