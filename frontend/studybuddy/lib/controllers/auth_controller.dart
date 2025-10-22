import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studybuddy/global_variables.dart';
import 'package:studybuddy/services/api_services.dart';
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
        onSuccess: () {
          print(response);
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
        onSuccess: () {
          print(response);
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
