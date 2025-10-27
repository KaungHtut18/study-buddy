import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studybuddy/ui/auth/login_screen.dart';
import 'package:studybuddy/ui/main_screen.dart';
import 'package:studybuddy/ui/match_service/match_notifier_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize notifications before runApp
  final matchService = MatchNotifierService();
  await matchService.init();
  final prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn');
  runApp(StudyBuddy(isLoggedIn: isLoggedIn));
}

class StudyBuddy extends StatelessWidget {
  final bool? isLoggedIn;
  const StudyBuddy({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          isLoggedIn != null && isLoggedIn == true
              ? MainScreen()
              : LoginScreen(),
    );
  }
}
