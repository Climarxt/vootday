import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/login/widgets/buttons_login.dart';
import 'package:bootdv2/screens/login/widgets/logo_title.dart';
import 'package:bootdv2/screens/login/widgets/text_login_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/login_cubit.dart';
import '/widgets/widgets.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
            return Padding(
              padding: const EdgeInsets.only(bottom: 19.0),
              child: Scaffold(
                appBar: const AppBarWhite(),
                body: Builder(
                  // Added Builder here
                  builder: (innerContext) => Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(innerContext).size.height -
                            Scaffold.of(innerContext).appBarMaxHeight! -
                            MediaQuery.of(innerContext).padding.top,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const LogoTitle(),
                          ButtonsLogin(),
                          const TextLoginPolicy(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
