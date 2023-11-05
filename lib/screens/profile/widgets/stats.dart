import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  final int count;
  final String label;

  const Stats({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        buildCountText(context),
      ],
    );
  }

  Text buildCountText(BuildContext context) {
    return Text(
      count.toString(),
      style: Theme.of(context).textTheme.headlineSmall!,
    );
  }
}
