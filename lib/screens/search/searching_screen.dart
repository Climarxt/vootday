import 'package:bootdv2/screens/comment/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SearchingScreen extends StatelessWidget {
  const SearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarComment(
            title: "Search",
          ),
      body: Center(
        child: Text(
          'Work In Progress',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
