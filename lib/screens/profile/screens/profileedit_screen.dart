import 'package:flutter/material.dart';

import 'package:bootdv2/screens/profile/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarProfile(title: "Edit profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            GestureDetector(
              child: const UserProfileImage(
                radius: 80.0,
                outerCircleRadius: 81,
                profileImageUrl: 'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fusers%2FuserProfile_b37d34b8-4557-4a4e-812f-688a46a72471.jpg?alt=media&token=f19bf10c-5d85-4301-be66-bb022b473502',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: 'Ctbast',
                      decoration: const InputDecoration(hintText: 'Username'),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      initialValue: 'Ma Bio de test',
                      decoration: const InputDecoration(hintText: 'Bio'),
                    ),
                    const SizedBox(height: 28.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {}, // Remplacez cette fonction par celle de votre application cible
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
