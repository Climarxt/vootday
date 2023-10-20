import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

ButtonTheme buildButtonDate(String date, String texte, BuildContext context) {
  return ButtonTheme(
    minWidth: double.infinity,
    child: OutlinedButton(
      onPressed: () {
        debugPrint('Received click');
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Text(date, style: AppTextStyles.displaySmallBold(context)),
            Text(texte, style: AppTextStyles.subtitleLargeGrey(context)),
          ],
        ),
      ),
    ),
  );
}
