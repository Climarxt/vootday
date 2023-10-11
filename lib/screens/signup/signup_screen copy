import 'package:app_6/screens/login/login_help_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/config.dart';
import '../login/cubit/login_cubit.dart';
import '../screens.dart';
import '/repositories/repositories.dart';
import 'cubit/signup_cubit.dart';
import '/widgets/widgets.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => BlocProvider<SignupCubit>(
              create: (_) =>
                  SignupCubit(authRepository: context.read<AuthRepository>()),
              child: SignupScreen(),
            ));
  }

  // static Route route() {
  //   return MaterialPageRoute(
  //     settings: const RouteSettings(name: routeName),
  //     builder: (context) => BlocProvider<SignupCubit>(
  //       create: (_) =>
  //           SignupCubit(authRepository: context.read<AuthRepository>()),
  //       child: SignupScreen(),
  //     ),
  //   );
  // }

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
                                  color: Colors.black,
                                  height: 64,
                                ),
                                const SizedBox(height: 34),
                                SvgPicture.asset(
                                  'assets/logo.svg',
                                  height: 64,
                                ),
                                const SizedBox(height: 64),
                                // Text Field USERNAME
                                TextFormField(
                                  decoration: InputDecoration(
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
                                      InputDecoration(hintText: 'Email'),
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
                                      InputDecoration(hintText: 'Mot de passe'),
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
                                GestureDetector(
                                  onTap: () => _submitForm(
                                    context,
                                    state.status == LoginStatus.submitting,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(25),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    decoration: BoxDecoration(
                                      color: couleurBleuClair1,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "S'inscrire",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 40),
                                // S'inscrire avec
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          "Ou s'inscrire avec",
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Google + Apple sign  buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    // google button
                                    SquareTile(
                                        imagePath: 'assets/logos/google.png'),

                                    SizedBox(width: 25),

                                    // apple button
                                    SquareTile(
                                        imagePath: 'assets/logos/apple.png')
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                            // J'ai un compte
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: const Text("J'ai un compte?"),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(LoginScreen.routeName),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: const Text(
                                      " Connexion",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
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
