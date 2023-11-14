import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/event/widgets/button_date.dart';
import 'package:bootdv2/screens/event/widgets/button_participants.dart';
import 'package:bootdv2/screens/event/widgets/button_price.dart';
import 'package:flutter/material.dart';

class ButtonsSectionEvent extends StatelessWidget {
  final int participants;
  final String reward;
  final DateTime dateEnd;
  final DateTime dateEvent;

  const ButtonsSectionEvent({
    super.key,
    required this.participants,
    required this.reward,
    required this.dateEnd,
    required this.dateEvent,
  });

  @override
  Widget build(BuildContext context) {
    return _buildButtonsSection(context);
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4.0, 18, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTwoButtons(
              participants,
              AppLocalizations.of(context)!.translate('participants'),
              "$reward€",
              AppLocalizations.of(context)!.translate('prizes'),
              context),
          const SizedBox(
            height: 10,
          ),
          _buildTwoButtonsDate(
              dateEnd,
              AppLocalizations.of(context)!.translate('dateend'),
              dateEvent,
              AppLocalizations.of(context)!.translate('dateevent'),
              context),
        ],
      ),
    );
  }

  Widget _buildTwoButtons(int count1, String label1, String count2,
      String label2, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: buildButtonParticipants(count1, label1, context)),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: buildButtonPrice(count2, label2, context)),
      ],
    );
  }

  Widget _buildTwoButtonsDate(DateTime date1, String label1, DateTime date2,
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
