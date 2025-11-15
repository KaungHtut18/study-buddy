import 'package:flutter/material.dart';
import 'package:studybuddy/ui/auth/login_screen.dart';
import 'package:studybuddy/widgets/reusable_textform_field.dart';
import 'package:studybuddy/widgets/reusable_textform_field_suffix.dart';

// Define a constant for the maximum desired width of the form on a web screen
const double _kMaxWebWidth = 450.0;

class InitialRegisterScreen extends StatefulWidget {
  final PageController pageController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  const InitialRegisterScreen({
    super.key,
    required this.pageController,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<InitialRegisterScreen> createState() => _InitialRegisterScreenState();
}

class _InitialRegisterScreenState extends State<InitialRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  // This mock list is not used in this screen's UI, but kept for context.
  // List<String> mockUniversityList = ['...'];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        // Set the background color for the entire web page
        backgroundColor: const Color(0xFFF7F7F7),
        body: Center(
          // Constrain the width for a web-friendly card look
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kMaxWebWidth),
            child: SingleChildScrollView(
              // Add overall vertical padding
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 25.0,
              ),
              child: Column(
                // Align content to the start (left) for better form layout
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and Titles (Centered)
                  Center(
                    child: Image.asset(
                      'assets/icons/sbuddy_icon.png',
                      width: 100, // Slightly reduced size
                      height: 100,
                    ),
                  ),
                  Center(
                    child: Text(
                      'StudyBuddy',
                      style: TextStyle(
                        fontFamily: 'Teachers-B',
                        fontWeight: FontWeight.bold,
                        fontSize: 24, // Larger title for web
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Join thousands of students',
                      style: TextStyle(
                        fontFamily: 'Teachers-M',
                        fontSize: 16, // Larger subtitle for web
                        color: Color(0xFF6D6D6D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Create Account Header
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontFamily: 'Teachers-B',
                      fontSize: 20, // Main section header
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Sign up to start your learning journey',
                    style: TextStyle(
                      fontFamily: 'Teachers-M',
                      fontSize: 16,
                      color: Color(0xFF6D6D6D),
                    ),
                  ),
                  const SizedBox(height: 30), // Increased spacing for web
                  // Full Name
                  Text(
                    'Full Name',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  reusableTextFormField(
                    controller: widget.nameController,
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person,
                    errorText: 'Please enter your full name',
                  ),
                  const SizedBox(height: 20), // Increased spacing
                  // Email Address
                  Text(
                    'Email Address',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  reusableTextFormField(
                    controller: widget.emailController,
                    hintText: 'Enter your email address',
                    prefixIcon: Icons.email,
                    errorText: 'Please enter a valid email address',
                  ),
                  const SizedBox(height: 20), // Increased spacing
                  // Password
                  Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  reusableTextFormFieldWithSuffixIcon(
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    toggleObscure: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    prefixIcon: Icons.lock,
                    controller: widget.passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20), // Increased spacing
                  // Confirm Password
                  Text(
                    'Confirm Password', // Corrected typo in label
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  reusableTextFormFieldWithSuffixIcon(
                    hintText: 'Please re-enter your password', // Adjusted hint
                    prefixIcon: Icons.lock,
                    obscureText: _obscureConfirmPassword,
                    toggleObscure: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    controller: widget.confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your confirm password';
                      }
                      if (value != widget.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Terms and Conditions Checkbox
                  // Removed `checkboxScaleFactor` and adjusted alignment for better web appearance
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              _isChecked = newValue ?? false;
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: Color(0xFF6664F1), // Use a primary color
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'I agree to the Terms of Services and Privacy Policy',
                          style: TextStyle(
                            fontFamily: 'Teachers-M',
                            fontSize: 14, // Larger text for web
                            color: Color(0xFF6D6D6D),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35), // Increased spacing
                  // Create Account Button
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (!_isChecked) {
                          // SnackBar is fine, but consider using a Dialog for critical web messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Colors.redAccent, // Better contrast for error
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'You must agree to our Terms and Conditions first',
                                style: TextStyle(
                                  fontFamily: 'Teachers-M',
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Navigate to the next page in the PageView
                          widget.pageController.animateToPage(
                            1, // SkillRegisterScreen index
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    child: Container(
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
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Teachers-B',
                            fontSize: 18, // Larger text for web
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontFamily: 'Teachers-M',
                          fontSize: 14,
                          color: Color(0xFF7C7C7C),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Teachers-B',
                            fontSize: 14,
                            color: Color(0xFF7B7B7B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Footer Text (Simplified and centered for better legibility)
                  Center(
                    child: Text(
                      'By signing up, you agree to our Terms and Privacy Policy',
                      style: TextStyle(
                        fontFamily: 'Teachers-M',
                        fontSize: 12,
                        color: Color(0xFF7C7C7C),
                      ),
                    ),
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
