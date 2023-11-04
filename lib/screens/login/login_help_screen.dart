import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginHelpScreen extends StatelessWidget {
  const LoginHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitle(
        title:
            AppLocalizations.of(context)!.translate('helptitle'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Vos Aides vont ici. '
          'Assurez-vous d\'inclure toutes les informations pertinentes concernant '
          'l\'utilisation de votre application, la confidentialité des données, '
          'les obligations de l\'utilisateur, etc.',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
