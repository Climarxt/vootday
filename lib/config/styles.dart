import 'package:bootdv2/config/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle bodyStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black);
  }

  static TextStyle bodyLinkBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: couleurBleuClair2, fontWeight: FontWeight.bold);
  }

  static TextStyle bodyTag(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: greyDark, fontWeight: FontWeight.bold);
  }

  static TextStyle titleLargeBlackBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(color: Colors.black, fontWeight: FontWeight.bold);
  }

  static TextStyle subtitleLargeGrey(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(color: greyDark);
  }
}
