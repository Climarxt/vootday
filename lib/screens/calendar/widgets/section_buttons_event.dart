import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/widgets/button_date.dart';
import 'package:flutter/material.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../profile/widgets/widgets.dart';

class ButtonsSectionEvent extends StatelessWidget {
  final ProfileState state;

  const ButtonsSectionEvent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return _buildButtonsSection(state, context);
  }

  Widget _buildButtonsSection(ProfileState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4.0, 18, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTwoButtons(820, "Participants", 100, "Prizes", context),
          const SizedBox(
            height: 10,
          ),
          _buildTwoButtonsDate(
              "27/03/2024",
              AppLocalizations.of(context)!.translate('dateend'),
              "31/03/2024",
              AppLocalizations.of(context)!.translate('dateevent'), context),
        ],
      ),
    );
  }

  Widget _buildTwoButtons(
      int count1, String label1, int count2, String label2, BuildContext context) {
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

  Widget _buildTwoButtonsDate(String date1, String label1, String date2,
      String label2, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: buildButtonDate(date1, label1, context)),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: buildButtonDate(date2, label2, context)),
      ],
    );
  }
}
