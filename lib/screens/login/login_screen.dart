import 'package:bootdv2/config/configs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'cubit/login_cubit.dart';
import '/widgets/widgets.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle defaultStyle = const TextStyle(color: grey, fontSize: 12.0);
  TextStyle linkStyle = const TextStyle(color: Colors.blue);

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 24),
                                SvgPicture.asset(
                                  'assets/logo.svg',
                                  height: 44,
                                ),
                                const SizedBox(width: 14),
                                SvgPicture.asset(
                                  'assets/ic_instagram.svg',
                                  height: 42,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 320.0),
                              child: SafeArea(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  width: double.infinity,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        MyButton(
                                            onTap: () => GoRouter.of(context)
                                                .go('/login/mail'),
                                            icon: 'assets/icons/email.svg',
                                            texte: "Connexion par mail"),
                                        const SizedBox(height: 6),
                                        MyButton(
                                            onTap: () => GoRouter.of(context)
                                                .go('/login/mail'),
                                            icon: 'assets/icons/cell-phone.svg',
                                            texte: "Connexion par téléphone"),
                                        const SizedBox(height: 6),
                                        MyButton(
                                            onTap: () => GoRouter.of(context)
                                                .go('/login/mail'),
                                            icon: 'assets/icons/google.svg',
                                            texte: "Connexion via Google"),
                                        const SizedBox(height: 6),
                                        MyButton(
                                            onTap: () => GoRouter.of(context)
                                                .go('/login/mail'),
                                            icon: 'assets/icons/apple.svg',
                                            texte: "Connexion via Apple"),
                                        const SizedBox(height: 6),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: const Text(
                                                  "Informations de connexion oubliées ?"),
                                            ),
                                            GestureDetector(
                                              onTap: () => GoRouter.of(context)
                                                  .go('/login/help'),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                ),
                                                child: const Text(
                                                  " Obtenez de l'aide",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: defaultStyle,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text:
                                            'En vous inscrivant, vous acceptez nos '),
                                    TextSpan(
                                      text:
                                          "Conditions Générales d'Utilisation. ",
                                      style: linkStyle,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => GoRouter.of(context)
                                            .go('/about'),
                                    ),
                                    const TextSpan(
                                        text:
                                            'Découvrez comment on utilise vos données en lisant notre '),
                                    TextSpan(
                                      text: 'Politique de Confidentialité.',
                                      style: linkStyle,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => GoRouter.of(context)
                                            .go('/about'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

/*   void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  } */
}
