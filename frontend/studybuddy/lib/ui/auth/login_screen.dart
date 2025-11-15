import 'package:flutter/material.dart';
import 'package:studybuddy/controllers/auth_controller.dart';
import 'package:studybuddy/ui/auth/register_page_view.dart';
import 'package:studybuddy/widgets/reusable_textform_field.dart';
import 'package:studybuddy/widgets/reusable_textform_field_suffix.dart';

// Define a constant for the maximum desired width of the form on a web screen
const double _kMaxWebWidth = 450.0;

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    // Note: In a real web app, consider adding a loading indicator here
    await _authController.login(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Wrap in `Form` for form validation
    return Form(
      key: _formKey,
      child: Scaffold(
        // 2. Set the background color for the entire web page
        backgroundColor: const Color(0xFFF7F7F7),
        // 3. Use `LayoutBuilder` for potential future responsiveness checks
        body: Center(
          // 4. Constrain the width of the content for a web-friendly card look
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kMaxWebWidth),
            child: SingleChildScrollView(
              // 5. Add overall vertical padding (less needed horizontally due to ConstrainedBox)
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 25.0,
              ),
              child: Column(
                // 6. Use `CrossAxisAlignment.start` for left-aligned labels (common in web forms)
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon
                  Center(
                    child: Image.asset(
                      'assets/icons/sbuddy_icon.png',
                      width: 122,
                      height: 122,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Welcome Back Title
                  Center(
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontFamily: 'Teachers-B',
                        fontWeight: FontWeight.bold,
                        fontSize: 28, // Slightly larger title for web
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Subtitle
                  Center(
                    child: Text(
                      'Sign in to Continue your learning journey',
                      style: TextStyle(
                        fontFamily: 'Teachers-M',
                        fontSize: 16, // Slightly larger subtitle for web
                        color: Color(0xFF6D6D6D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // Increased spacing for web
                  // Email Label
                  Text(
                    'Email Address',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Adjusted vertical spacing
                  // Email Field
                  reusableTextFormField(
                    controller: emailController,
                    hintText: 'Enter your email address',
                    prefixIcon: Icons.email,
                    errorText: 'Please enter a valid email address',
                  ),
                  const SizedBox(height: 20), // Increased spacing
                  // Password Label
                  Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Adjusted vertical spacing
                  // Password Field
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
                  const SizedBox(height: 10),

                  // Forgot Password?
                  Align(
                    alignment: Alignment.centerRight, // Align to the right
                    child: GestureDetector(
                      onTap: () {
                        // Handle navigation to forgot password page
                        print('Forgot password tapped!');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Teachers-B',
                          fontSize: 14, // Slightly larger for web
                          color: Color(0xFF6D6D6D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35), // Increased spacing for web
                  // Sign In Button
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: Container(
                      // The width will now respect the ConstrainedBox's width (max 450)
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
                            fontSize: 18, // Slightly larger text for web
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Increased spacing
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          fontFamily: 'Teachers-M',
                          fontSize: 14, // Slightly larger text for web
                          color: Color(0xFF7C7C7C),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Note: Consider using named routes for web navigation
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
                            fontSize: 14, // Slightly larger text for web
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
