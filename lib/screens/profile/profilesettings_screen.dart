import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/widgets/appbar/appbar_title_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarProfile(title: "Settings"),
      body: ListView(
        children: [
          buildSettingsCategory(
            context,
            'Paramètres du compte',
            [
              buildSettingsItem(
                context,
                FontAwesomeIcons.user,
                'Gestion du compte',
                onTap: () {},
              ),
              buildSettingsItem(
                context,
                FontAwesomeIcons.key,
                'Mot de passe',
                onTap: () {},
              ),
            ],
          ),
          buildSettingsCategory(
            context,
            'Confidentialité',
            [
              buildSettingsItem(
                context,
                FontAwesomeIcons.userShield,
                'Confidentialité du compte',
                onTap: () {},
              ),
            ],
          ),
          buildSettingsCategory(
            context,
            'Plus d\'info et d\'assistance',
            [
              buildSettingsItem(
                context,
                FontAwesomeIcons.circleQuestion,
                'Aide',
                onTap: () {},
              ),
              buildSettingsItem(
                context,
                FontAwesomeIcons.info,
                'À propros',
                onTap: () {},
              ),
            ],
          ),
          buildSettingsCategory(
            context,
            'Déconnexion',
            [
              buildSettingsItem(
                context,
                // ignore: deprecated_member_use
                FontAwesomeIcons.signOutAlt,
                'Se déconnecter',
                onTap: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSettingsCategory(
      BuildContext context, String title, List<Widget> settingsItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.black),
          ),
        ),
        ...settingsItems,
      ],
    );
  }

  Widget buildSettingsItem(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
