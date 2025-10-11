import 'package:flutter/material.dart';
import 'package:studybuddy/ui/auth/login.dart';
import 'package:studybuddy/ui/main_screen.dart';

void main() {
  runApp(const StudyBuddy());
}

class StudyBuddy extends StatelessWidget {
  const StudyBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}
