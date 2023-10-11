import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  final int count;
  final String label;

  const Stats({
    Key? key,
    required this.count,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildCountText(),
        buildIcon(),
      ],
    );
  }

  Text buildCountText() {
    return Text(
      count.toString(),
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Icon buildIcon() {
    IconData iconData;

    switch (label) {
      case 'posts':
        iconData = Icons.add_a_photo; // Replace with desired icon for posts
        break;
      case 'followers':
        iconData = Icons.person_add; // Replace with desired icon for followers
        break;
      case 'following':
        iconData = Icons.people; // Replace with desired icon for following
        break;
      case 'stars':
        iconData = Icons.star; // Replace with desired icon for following
        break;
      default:
        iconData =
            Icons.error; // Default icon in case label does not match any case
    }

    return Icon(
      iconData,
      color: Colors.black,
    );
  }
}
