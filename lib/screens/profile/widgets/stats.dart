import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  final int count;
  final String label;

  const Stats({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Démarrez l'animation après un certain délai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _opacity = 1.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 300),
          child: Text(
            widget.count.toString(),
            style: Theme.of(context).textTheme.headlineSmall!,
          ),
        ),
      ],
    );
  }
}
