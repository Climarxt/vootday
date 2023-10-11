import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prevState, state) =>
          prevState.status == AuthStatus.unknown ||
          state.status ==
              AuthStatus
                  .authenticated, // Only run on first launch. Run on first launch OR on sign up/in.
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          // Go to the Login Screen.
          //Navigator.of(context).pushNamed(LoginScreen.routeName);
        } else if (state.status == AuthStatus.authenticated) {
          // Go to the Nav Screen.
          Navigator.of(context).pushNamed(NavScreen.routeName);
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
