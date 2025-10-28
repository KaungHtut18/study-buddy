import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studybuddy/global_variables.dart';
import 'package:studybuddy/services/api_services.dart';
import 'package:studybuddy/services/service_provider.dart';
import 'package:studybuddy/ui/main_screen.dart';

class AuthController {
  Future<void> registerUser({
    required BuildContext context,
    required String fullName,
    required String email,
    required String password,
    required List<String> interests,
    required List<String> skills,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/security/register'),
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "userName": fullName,
          "password": password,
          "interests": interests,
          "skills": skills,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      handleResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          final serviceProvider = Provider.of<ServiceProvider>(
            context,
            listen: false,
          );
          serviceProvider.setUserId(jsonDecode(response.body)['data']['id']);
          serviceProvider.setUserName(
            jsonDecode(response.body)['data']['userName'],
          );
          serviceProvider.setInteresting(
            List<String>.from(jsonDecode(response.body)['data']['interests']),
          );
          serviceProvider.setSkills(
            List<String>.from(jsonDecode(response.body)['data']['skills']),
          );
          print('----------------------------------------------');
          print(serviceProvider.skills);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
          showSnackBar(context, 'Account has been successfully created');
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/security/login'),
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "password": password,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      handleResponse(
        response: response,
        context: context,
        onSuccess: () async {
          print(response);
          final serviceProvider = Provider.of<ServiceProvider>(
            context,
            listen: false,
          );
          serviceProvider.setUserId(jsonDecode(response.body)['data']['id']);
          serviceProvider.setUserName(
            jsonDecode(response.body)['data']['userName'],
          );
          serviceProvider.setInteresting(
            List<String>.from(jsonDecode(response.body)['data']['interests']),
          );
          serviceProvider.setSkills(
            List<String>.from(jsonDecode(response.body)['data']['skills']),
          );
          print('----------------------------------------------');
          print(serviceProvider.skills);
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
          showSnackBar(context, 'Successfully Logged In');
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }
}
