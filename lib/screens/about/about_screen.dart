import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres et confidentialité'),
      ),
      body: ListView(
        children: [
          buildSettingsCategory(
            context,
            'Paramètres du compte',
            [
              buildSettingsItem(
                context,
                FontAwesomeIcons.textHeight,
                "Conditions Générales d'Utilisation.",
                onTap: () => GoRouter.of(context).go('/about/conditionsgen'),
              ),
              buildSettingsItem(
                context,
                FontAwesomeIcons.key,
                'Politique de Confidentialité.',
                onTap: () => GoRouter.of(context).go('/about/policies'),
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
