import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

ButtonTheme buildButton(int num, String texte, BuildContext context) {
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
            Text(num.toString(),
                style: AppTextStyles.displaySmallBold(context)),
            Text(texte, style: AppTextStyles.subtitleLargeGrey(context)),
          ],
        ),
      ),
    ),
  );
}

ButtonTheme buildButtonOnClickIndex0(int num, String texte,
    BuildContext context, String route, String userId, int index0) {
  return ButtonTheme(
    minWidth: double.infinity,
    child: OutlinedButton(
      onPressed: () {
        _navigateToScreenIndex0(context, route, userId, index0);
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Text(num.toString(),
                style: AppTextStyles.displaySmallBold(context)),
            Text(texte, style: AppTextStyles.subtitleLargeGrey(context)),
          ],
        ),
      ),
    ),
  );
}

void _navigateToScreenIndex0(
    BuildContext context, String route, String userId, int index0) {
  GoRouter.of(context)
      .push('$route?userId=$userId', extra: {'initialTabIndex': index0});
}

ButtonTheme buildButtonOnClickIndex1(int num, String texte,
    BuildContext context, String route, String userId, int index1) {
  return ButtonTheme(
    minWidth: double.infinity,
    child: OutlinedButton(
      onPressed: () {
        _navigateToScreenIndex1(context, route, userId, index1);
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Text(num.toString(),
                style: AppTextStyles.displaySmallBold(context)),
            Text(texte, style: AppTextStyles.subtitleLargeGrey(context)),
          ],
        ),
      ),
    ),
  );
}

void _navigateToScreenIndex1(
    BuildContext context, String route, String userId, int index1) {
  GoRouter.of(context)
      .push('$route?userId=$userId', extra: {'initialTabIndex': index1});
}
