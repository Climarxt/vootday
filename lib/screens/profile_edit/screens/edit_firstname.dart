// ignore_for_file: library_private_types_in_public_api

import 'package:bootdv2/screens/profile_edit/cubit/edit_profile_cubit.dart';
import 'package:bootdv2/screens/profile_edit/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_profile.dart';

class EditFirstnameScreen extends StatefulWidget {
  final String userId;

  const EditFirstnameScreen({
    super.key,
    required this.userId,
  });

  @override
  _EditFirstnameScreenState createState() => _EditFirstnameScreenState();
}

class _EditFirstnameScreenState extends State<EditFirstnameScreen> {
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
        appBar: const AppBarProfile(title: "Edit Firstname"),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              ErrorDialog(content: state.failure.message);
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
                      Container(
                        color: red,
                      )
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
}
