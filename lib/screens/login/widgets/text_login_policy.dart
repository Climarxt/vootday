import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

class TextLoginPolicy extends StatelessWidget {
  const TextLoginPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodyStyle(context),
              children: <TextSpan>[
                TextSpan(
                  text: AppLocalizations.of(context)!
                      .translate('termsAndConditions'),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!
                      .translate('termsLink'),
                  style: AppTextStyles.bodyLinkBold(context),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => GoRouter.of(context).go('/about'),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!
                      .translate('privacyPolicy'),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!
                      .translate('privacyLink'),
                  style: AppTextStyles.bodyLinkBold(context),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => GoRouter.of(context).go('/privacy'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
