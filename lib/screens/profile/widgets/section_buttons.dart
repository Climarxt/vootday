import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class ButtonsSection extends StatelessWidget {
  final ProfileState state;

  const ButtonsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return _buildButtonsSection(state, context);
  }

  Widget _buildButtonsSection(ProfileState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTwoButtons(state.posts.length, "OOTD", 0, "BOOTD", context),
          const SizedBox(
            height: 10,
          ),
          _buildTwoButtonsOnclick(
            state.user.following,
            AppLocalizations.of(context)!.translate('followingsCap'),
            "/followersfollowingscreen",
            state.user.followers,
            AppLocalizations.of(context)!.translate('followersCap'),
            "/followersfollowingscreen",
            context,
            state.user.id,
            0, // Index pour l'onglet "Following"
            1, // Index pour l'onglet "Followers"
          ),
        ],
      ),
    );
  }

  Widget _buildTwoButtons(int count1, String label1, int count2, String label2,
      BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: buildButton(count1, label1, context)),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: buildButton(count2, label2, context)),
      ],
    );
  }

  Widget _buildTwoButtonsOnclick(
      int count1,
      String label1,
      String route1,
      int count2,
      String label2,
      String route2,
      BuildContext context,
      String userId,
      int index0,
      int index1) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: buildButtonOnClickIndex0(
                count1, label1, context, route1, userId, index0)),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: buildButtonOnClickIndex1(
                count2, label2, context, route2, userId, index1)),
      ],
    );
  }
}
