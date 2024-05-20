// ignore_for_file: library_private_types_in_public_api

import 'package:bootdv2/screens/profile_edit/widgets/appbar_title_editprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';

class EditLinksScreen extends StatefulWidget {
  final String userId;

  const EditLinksScreen({
    super.key,
    required this.userId,
  });

  @override
  _EditLinksScreenState createState() => _EditLinksScreenState();
}

class _EditLinksScreenState extends State<EditLinksScreen> {
  final TextEditingController _bioController = TextEditingController();
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
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const AppBarEditProfile(title: "Edit Links"),
          body: _buildForm(context, state),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, ProfileState profileState) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(context, 'Instagram', profileState.user.socialInstagram,
                navigateToEditLinkInstagram),
            const SizedBox(height: 12),
            _buildField(context, 'Tiktok', profileState.user.socialTiktok,
                navigateToEditLinkTiktok),
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

  // Navigates to the 'Edit Link Instagram' screen.
  void navigateToEditLinkInstagram(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editlinks/instagram');
  }

  // Navigates to the 'Edit Link TikTok' screen.
  void navigateToEditLinkTiktok(BuildContext context) {
    GoRouter.of(context).push('/editprofile/editusername');
  }
}
