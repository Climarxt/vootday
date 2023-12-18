import 'package:bootdv2/config/configs.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MeButton extends StatefulWidget {
  const MeButton({
    super.key,
  });

  @override
  State<MeButton> createState() => _MeButtonState();
}

class _MeButtonState extends State<MeButton> {
  @override
  Widget build(BuildContext context) {
    return buildMeButton(context);
  }

  // Builds the 'Follow/Unfollow' button.
  TextButton buildMeButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: couleurBleuClair2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rayon des bords arrondis
        ),
      ),
      onPressed: () => GoRouter.of(context).go('/profile'),
      child: Text(
        AppLocalizations.of(context)!.translate('editProfile'),
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
      ),
    );
  }
}
