import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '/repositories/repositories.dart';
import 'cubit/signup_cubit.dart';
import '/widgets/widgets.dart';

class SignupDemoScreen extends StatelessWidget {
  static const String routeName = '/signupdemo';

  SignupDemoScreen({super.key});

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => BlocProvider<SignupCubit>(
              create: (_) =>
                  SignupCubit(authRepository: context.read<AuthRepository>()),
              child: SignupDemoScreen(),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      width: double.infinity,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // svg image
                                SvgPicture.asset(
                                  'assets/ic_instagram.svg',
                                  // ignore: deprecated_member_use
                                  color: Colors.black,
                                  height: 64,
                                ),
                                const SizedBox(height: 64),
                                // Text Field USERNAME
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: "Nom d'utilisateur"),
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .usernameChanged(value),
                                  validator: (value) => value!.trim().isEmpty
                                      ? 'Veuillez saisir un nom d\'utilisateur valide.'
                                      : null,
                                ),
                                const SizedBox(height: 24),
                                // Text Field Email
                                TextFormField(
                                  decoration:
                                      const InputDecoration(hintText: 'Email'),
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .emailChanged(value),
                                  validator: (value) => !value!.contains('@')
                                      ? 'Veuillez saisir une adresse e-mail valide.'
                                      : null,
                                ),
                                const SizedBox(height: 24),
                                // Text Field Password
                                TextFormField(
                                  decoration:
                                      const InputDecoration(hintText: 'Mot de passe'),
                                  obscureText: true,
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .passwordChanged(value),
                                  validator: (value) => value!.length < 6
                                      ? 'Doit comporter au moins 6 caractères.'
                                      : null,
                                ),
                                const SizedBox(height: 24),
                                // S'inscrire Button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => _submitForm(
                                    context,
                                    state.status == SignupStatus.submitting,
                                  ),
                                  child: const Text('S\'inscrire'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}
