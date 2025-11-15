import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studybuddy/services/service_provider.dart';
import 'package:studybuddy/ui/auth/login_screen.dart';
import 'package:studybuddy/ui/main_screen.dart';
import 'package:studybuddy/services/match_notifier_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ServiceProvider())],
      child: StudyBuddy(),
    ),
  );
}

class StudyBuddy extends StatelessWidget {
  const StudyBuddy({super.key});

  Future<Map<String, dynamic>> _initApp() async {
    // Initialize services and shared preferences
    final matchService = MatchNotifierService();
    await matchService.init();

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return {'isLoggedIn': isLoggedIn};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _initApp(),
      builder: (context, snapshot) {
        // Loading screen while initializing
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        bool isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isLoggedIn ? MainScreen() : LoginScreen(),
        );
      },
    );
  }
}
