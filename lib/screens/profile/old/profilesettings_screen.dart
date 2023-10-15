import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: [
          buildSettingsCategory(
            context,
            'Paramètres du compte',
            [
              buildSettingsItem(
                context,
                FontAwesomeIcons.user,
                'Nom d\'utilisateur',
                onTap: () {
                  // Mettez ici le code pour naviguer vers la page du nom d'utilisateur
                },
              ),
              buildSettingsItem(
                context,
                FontAwesomeIcons.key,
                'Mot de passe',
                onTap: () {
                  // Mettez ici le code pour naviguer vers la page du mot de passe
                },
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
                onTap: () {
                  // Mettez ici le code pour naviguer vers la page de confidentialité du compte
                },
              ),
            ],
          ),
          // Ajoutez d'autres catégories ici...
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
            style: const TextStyle(fontWeight: FontWeight.bold),
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
