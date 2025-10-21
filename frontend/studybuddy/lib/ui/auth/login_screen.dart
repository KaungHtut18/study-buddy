import 'package:flutter/material.dart';
import 'package:studybuddy/controllers/auth_controller.dart';
import 'package:studybuddy/ui/auth/register_page_view.dart';
import 'package:studybuddy/widgets/reusable_textform_field.dart';
import 'package:studybuddy/widgets/reusable_textform_field_suffix.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool _obscurePassword = true;
  final AuthController _authController = AuthController();

  void login() async {
    await _authController.login(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icons/sbuddy_icon.png',
                      width: 122,
                      height: 122,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontFamily: 'Teachers-B',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Sign in to Continue your learning journey',
                      style: TextStyle(
                        fontFamily: 'Teachers-M',
                        fontSize: 14,
                        color: Color(0xFF6D6D6D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Email Address',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  reusableTextFormField(
                    controller: emailController,
                    hintText: 'Enter your email address',
                    prefixIcon: Icons.email,
                    errorText: 'Please enter a valid email address',
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  reusableTextFormFieldWithSuffixIcon(
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    toggleObscure: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Teachers-B',
                        fontSize: 12,
                        color: Color(0xFF6D6D6D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: Container(
                      width: 370,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6664F1), Color(0xFF8B66AF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Teachers-B',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          fontFamily: 'Teachers-M',
                          fontSize: 12,
                          color: Color(0xFF7C7C7C),
                        ),
                      ),
                      GestureDetector(
                        //to navigate to register screen
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPageView(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Register Here',
                          style: TextStyle(
                            fontFamily: 'Teachers-B',
                            fontSize: 12,
                            color: Color(0xFF7B7B7B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
