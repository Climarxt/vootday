import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class CustomTextFieldLocation extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextFieldLocation({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 50.0,
      ),
      child: TextField(
        cursorColor: couleurBleuClair2,
        style: AppTextStyles.titleSmallGrey(context),
        controller: controller,
        maxLines: null,
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
