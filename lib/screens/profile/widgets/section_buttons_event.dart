import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import '../bloc/profile_bloc.dart';
import 'widgets.dart';

class ButtonsSectionEvent extends StatelessWidget {
  final ProfileState state;

  const ButtonsSectionEvent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return _buildButtonsSection(state,context);
  }

  Widget _buildButtonsSection(ProfileState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4.0, 18, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTwoButtons(820, "Participants", 100, "Prizes"),
          const SizedBox(
            height: 10,
          ),
          _buildTwoButtons(state.user.following, AppLocalizations.of(context)!.translate('followingsCap'),
              state.user.followers, AppLocalizations.of(context)!.translate('followersCap')),
        ],
      ),
    );
  }

  Widget _buildTwoButtons(
      int count1, String label1, int count2, String label2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: buildButton(count1, label1)),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: buildButton(count2, label2)),
      ],
    );
  }
}
