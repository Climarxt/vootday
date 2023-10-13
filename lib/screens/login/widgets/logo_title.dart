import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package

class LogoTitle extends StatelessWidget {
  const LogoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/logo.svg',
          height: 44,
        ),
        const SizedBox(width: 14),
        SvgPicture.asset(
          'assets/images/ic_instagram.svg',
          height: 42,
        ),
      ],
    );
  }
}
