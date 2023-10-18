import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import '../bloc/profile_bloc.dart';

class AboutSection extends StatelessWidget {
  final ProfileState state;
  const AboutSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return _buildAboutSection(state,context);
  }

  Widget _buildAboutSection(ProfileState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('about'),
          style: Theme.of(context).textTheme.headlineSmall!,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          state.user.bio,
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ],
    );
  }
}
