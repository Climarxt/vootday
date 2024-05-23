import 'package:flutter/material.dart';
import 'package:bootdv2/config/configs.dart';

class TitleBar extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onIconPressed;

  const TitleBar({
    super.key,
    required this.context,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: white,
        height: 48,
        child: Stack(
          children: [
            Center(
              child: Text(
                'Votre Titre',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.black),
              ),
            ),
            Positioned(
              right: 16.0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onIconPressed,
                child: const Icon(Icons.event),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
