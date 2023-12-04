import 'package:bootdv2/screens/comment/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CommentWIPScreen extends StatelessWidget {
  const CommentWIPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarComment(
            title: "Comments",
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
