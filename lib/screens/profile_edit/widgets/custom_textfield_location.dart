import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class CustomTextFieldLocation extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextFieldLocation({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 50.0, // Hauteur minimale du champ de texte
      ),
      child: TextField(
        cursorColor: couleurBleuClair2,
        style: AppTextStyles.titleSmallGrey(context),
        controller: controller,
        maxLines: null, // Permet au TextField de s'agrandir verticalement
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          floatingLabelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        enabled: false,
      ),
    );
  }
}
