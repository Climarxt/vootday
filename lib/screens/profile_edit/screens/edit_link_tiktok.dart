// ignore_for_file: library_private_types_in_public_api

import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_editprofile.dart';
import 'package:bootdv2/screens/profile_edit/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile_edit/cubit/edit_profile_cubit.dart';
import 'package:bootdv2/screens/profile_edit/widgets/error_dialog.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:url_launcher/url_launcher.dart';

class EditLinkTiktokScreen extends StatefulWidget {
  final String userId;

  const EditLinkTiktokScreen({
    super.key,
    required this.userId,
  });

  @override
  _EditLinkTiktokScreenState createState() => _EditLinkTiktokScreenState();
}

class _EditLinkTiktokScreenState extends State<EditLinkTiktokScreen> {
  final TextEditingController _socialTiktokController = TextEditingController();

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
    _socialTiktokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState.status == ProfileStatus.loaded &&
              _socialTiktokController.text.isEmpty) {
            _socialTiktokController.text = profileState.user.socialTiktok;
          }

          return Scaffold(
            appBar: const AppBarEditProfile(title: "TikTok"),
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
                        controller: _socialTiktokController,
                        labelText: 'TikTok',
                        onChanged: (value) {
                          context
                              .read<EditProfileCubit>()
                              .socialTiktokChanged(value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        AppLocalizations.of(context)!
                            .translate('redirectToTikTok'),
                        style: AppTextStyles.bodySmallStyleGrey(context),
                      ),
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
        final currentsocialTiktok = _socialTiktokController.text.isEmpty
            ? profileState.user.socialTiktok
            : _socialTiktokController.text;
        context
            .read<EditProfileCubit>()
            .socialTiktokChanged(currentsocialTiktok);
        context.read<EditProfileCubit>().submitSocialTiktokChange();
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
