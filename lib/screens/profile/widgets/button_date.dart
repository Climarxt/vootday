import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bootdv2/config/configs.dart'; // Assurez-vous que ce fichier contient AppTextStyles

ButtonTheme buildButtonDate(DateTime date, String texte, BuildContext context) {
  // Formattez la date en utilisant DateFormat.
  // Par exemple, pour un format comme "EEE, MMM d, yyyy", ce qui pourrait donner "Tue, Jul 10, 2021".
  String formattedDate = DateFormat('dd/MM/yyyy').format(date);
  
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
            // Utilisez la date formatée ici
            Text(formattedDate, style: AppTextStyles.displaySmallBold(context)),
            Text(texte, style: AppTextStyles.subtitleLargeGrey(context)),
          ],
        ),
      ),
    ),
  );
}
