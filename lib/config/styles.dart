import 'package:bootdv2/config/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle bodyStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: Colors.black);
  }

  static TextStyle bodyLinkBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: couleurBleuClair2, fontWeight: FontWeight.bold);
  }
}
