import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/configs.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String icon;
  final String? texte;

  const MyButton(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.texte});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: grey),
          color: white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 22,
              ),
              const SizedBox(width: 10),
              Text(
                texte!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
