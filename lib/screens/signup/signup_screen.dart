import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/configs.dart';
import '../login/cubit/login_cubit.dart';
import 'cubit/signup_cubit.dart';
import '/widgets/widgets.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: _signupStateListener,
          builder: (context, state) => _buildSignupForm(context, state),
        ),
      ),
    );
  }

  void _signupStateListener(BuildContext context, SignupState state) {
    if (state.status == SignupStatus.error) {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(content: state.failure.message),
      );
    }
  }

  Widget _buildSignupForm(BuildContext context, SignupState state) {
    String? selectedGender;

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
                  _buildMainColumn(context, selectedGender),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildMainColumn(BuildContext context, String? selectedGender) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogos(),
        _buildUsernameField(context),
        _buildEmailField(context),
        _buildGenderDropdown(context, selectedGender),
        _buildPasswordField(context),
        _buildSignupButton(context),
        _buildOrSignupWithText(),
        _buildSocialButtons(),
      ],
    );
  }

  Widget _buildLogos() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/ic_instagram.svg',
          color: Colors.black,
          height: 64,
        ),
        const SizedBox(height: 34),
        SvgPicture.asset(
          'assets/images/logo.svg',
          height: 64,
        ),
        const SizedBox(height: 34),
      ],
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(hintText: "Nom d'utilisateur"),
          onChanged: (value) =>
              context.read<SignupCubit>().usernameChanged(value),
          validator: (value) => value!.trim().isEmpty
              ? 'Veuillez saisir un nom d\'utilisateur valide.'
              : null,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(hintText: 'Email'),
          onChanged: (value) => context.read<SignupCubit>().emailChanged(value),
          validator: (value) => !value!.contains('@')
              ? 'Veuillez saisir une adresse e-mail valide.'
              : null,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildGenderDropdown(BuildContext context, String? selectedGender) {
    return Column(
      children: [
        DropdownButtonFormField(
          decoration: const InputDecoration(
            hintText: 'Genre',
            labelText: 'Choisir un genre',
          ),
          value: selectedGender,
          items: const [
            DropdownMenuItem(
              child: Text("Masculin"),
              value: 'Masculin',
            ),
            DropdownMenuItem(
              child: Text("Féminin"),
              value: 'Féminin',
            ),
          ],
          onChanged: (value) {
            selectedGender = value as String?;
            context.read<SignupCubit>().selectedGenderChanged(selectedGender!);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(hintText: 'Mot de passe'),
          obscureText: true,
          onChanged: (value) =>
              context.read<SignupCubit>().passwordChanged(value),
          validator: (value) => value!.length < 6
              ? 'Doit comporter au moins 6 caractères.'
              : null,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _submitForm(
        context,
        // Remarque : Ce serait SignupStatus.submitting si vous avez un état similaire dans SignupCubit
        context.read<SignupCubit>().state.status == SignupStatus.submitting,
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
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
    );
  }

  Widget _buildOrSignupWithText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey[400],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Ou s'inscrire avec",
              style: TextStyle(color: Colors.grey[700]),
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
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SquareTile(imagePath: 'assets/logos/google.png'),
        SizedBox(width: 25),
        SquareTile(imagePath: 'assets/logos/apple.png'),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: const Text("J'ai un compte?"),
        ),
        GestureDetector(
          onTap: () => GoRouter.of(context).go('/login'),
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
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}
