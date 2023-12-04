import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/login/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

class ButtonsLogin extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ButtonsLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                MyButton(
                  onTap: () => GoRouter.of(context).go('/login/mail'),
                  icon: 'assets/icons/email.svg',
                  texte:
                      AppLocalizations.of(context)!.translate('connectbymail'),
                ),
                const SizedBox(height: 6),
                MyButton(
                  onTap: () => GoRouter.of(context).go('/login/mail'),
                  icon: 'assets/icons/cell-phone.svg',
                  texte:
                      AppLocalizations.of(context)!.translate('connectbytel'),
                ),
                const SizedBox(height: 6),
                MyButton(
                  onTap: () => GoRouter.of(context).go('/login/mail'),
                  icon: 'assets/icons/google.svg',
                  texte: AppLocalizations.of(context)!
                      .translate('connectbygoogle'),
                ),
                const SizedBox(height: 6),
                MyButton(
                  onTap: () => GoRouter.of(context).go('/login/mail'),
                  icon: 'assets/icons/apple.svg',
                  texte:
                      AppLocalizations.of(context)!.translate('connectbyapple'),
                ),
                const SizedBox(height: 18),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.bodyStyle(context),
                    children: <TextSpan>[
                      TextSpan(
                        text: AppLocalizations.of(context)!
                            .translate('forgottenlogins'),
                      ),
                      const TextSpan(
                        text: '\n',
                      ),
                      TextSpan(
                        text:
                            AppLocalizations.of(context)!.translate('askhelp'),
                        style: AppTextStyles.bodyLinkBold(context),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => GoRouter.of(context).go('/login/help'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
