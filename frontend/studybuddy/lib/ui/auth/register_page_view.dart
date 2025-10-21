import 'package:flutter/material.dart';
import 'package:studybuddy/ui/auth/register_screens/initial_register_screen.dart';
import 'package:studybuddy/ui/auth/register_screens/skill_register_screen.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  final _pageController = PageController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: PageView(
        controller: _pageController,
        onPageChanged:
            (value) => {
              setState(() {
                currentPage = value;
              }),
            },
        children: [
          InitialRegisterScreen(
            pageController: _pageController,
            nameController: nameController,
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
          ),
          SkillRegisterScreen(
            nameController: nameController,
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}
