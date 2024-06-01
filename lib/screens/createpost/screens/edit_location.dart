// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/createpost/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_editprofile.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:go_router/go_router.dart';

class EditLocationCreatePostScreen extends StatefulWidget {
  final String userId;

  const EditLocationCreatePostScreen({
    super.key,
    required this.userId,
  });

  @override
  _EditLocationCreatePostScreenState createState() =>
      _EditLocationCreatePostScreenState();
}

class _EditLocationCreatePostScreenState
    extends State<EditLocationCreatePostScreen> {
  final TextEditingController _locationController = TextEditingController();
  String? _selectedLocationType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          if (profileState.status == ProfileStatus.loaded) {
            final locationCity = profileState.user.locationCity;
            final locationState = profileState.user.locationState;
            final locationCountry = profileState.user.locationCountry;
            final currentLocation =
                context.read<CreatePostCubit>().state.locationSelected;

            return Scaffold(
              appBar: AppBarEditProfile(
                title: AppLocalizations.of(context)!.translate('editLocation'),
              ),
              body: BlocConsumer<CreatePostCubit, CreatePostState>(
                listener: (context, state) =>
                    _handleCreatePostStateChanges(context, state),
                builder: (context, editState) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            RadioListTile<String>(
                              title: Text(locationCity),
                              value: locationCity,
                              groupValue: currentLocation,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocationType = value;
                                  _locationController.text = locationCity;
                                  context
                                      .read<CreatePostCubit>()
                                      .locationSelectedChanged(locationCity);
                                });
                              },
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: couleurBleuClair2,
                            ),
                            RadioListTile<String>(
                              title: Text(locationState),
                              value: locationState,
                              groupValue: currentLocation,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocationType = value;
                                  _locationController.text = locationState;
                                  context
                                      .read<CreatePostCubit>()
                                      .locationSelectedChanged(locationState);
                                });
                              },
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: couleurBleuClair2,
                            ),
                            RadioListTile<String>(
                              title: Text(locationCountry),
                              value: locationCountry,
                              groupValue: currentLocation,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocationType = value;
                                  _locationController.text = locationCountry;
                                  context
                                      .read<CreatePostCubit>()
                                      .locationSelectedChanged(locationCountry);
                                });
                              },
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: couleurBleuClair2,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('helpCreatePostLocalisation'),
                          style: AppTextStyles.bodySmallStyleGrey(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              floatingActionButton: _buildFloatingActionButton(context),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
          return const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)),
          );
        },
      ),
    );
  }

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

  void _resetForm(BuildContext context) {
    _formKey.currentState!.reset();
    context.read<CreatePostCubit>().reset();
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
