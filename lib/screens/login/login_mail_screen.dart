import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/login/cubit/login_cubit.dart';
import 'package:bootdv2/screens/login/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginMailScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                              'assets/images/logo.svg',
                              height: 44,
                            ),
                            const SizedBox(width: 14),
                            SvgPicture.asset(
                              'assets/images/ic_instagram.svg',
                              height: 42,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          width: double.infinity,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 200),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: 'Email'),
                                        onChanged: (value) => context
                                            .read<LoginCubit>()
                                            .emailChanged(value),
                                        validator: (value) => !value!
                                                .contains('@')
                                            ? 'Veuillez saisir une adresse e-mail valide.'
                                            : null,
                                      ),
                                      const SizedBox(height: 24),
                                      // text field input for password
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: 'Password'),
                                        obscureText: true,
                                        onChanged: (value) => context
                                            .read<LoginCubit>()
                                            .passwordChanged(value),
                                        validator: (value) => value!.length <
                                                6
                                            ? 'Doit comporter au moins 6 caractères.'
                                            : null,
                                      ),
                                      const SizedBox(height: 43),
                                      GestureDetector(
                                        onTap: () => _submitForm(
                                          context,
                                          state.status ==
                                              LoginStatus.submitting,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          decoration: BoxDecoration(
                                            color: couleurBleuClair1,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Se connecter",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      GoRouter.of(context).go('/login'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    child: const Text(
                                      "Autre mode de connexion",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      GoRouter.of(context).go('/signup'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                    child: const Text(
                                      "Inscription test",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
