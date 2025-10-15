import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:studybuddy/ui/auth/login_screen.dart';
import 'package:studybuddy/widgets/reusable_textform_field.dart';
import 'package:studybuddy/widgets/reusable_textform_field_suffix.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  List<String> mockUniversityList = [
    'Mae Fah Luang University',
    'Chiang Mai University',
    'Mahidol University',
  ];
  String? _selectedValue;

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
                      'StudyBuddy',
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
                      'Join thousands of students',
                      style: TextStyle(
                        fontFamily: 'Teachers-M',
                        fontSize: 14,
                        color: Color(0xFF6D6D6D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Create Account',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Teachers-B',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Sign up to start your learning journey',
                    style: TextStyle(
                      fontFamily: 'Teachers-M',
                      fontSize: 14,
                      color: Color(0xFF6D6D6D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Full Name',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  reusableTextFormField(
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person,
                    errorText: 'Please enter your full name',
                  ),
                  const SizedBox(height: 10),
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
                    hintText: 'Enter your email address',
                    prefixIcon: Icons.email,
                    errorText: 'Please enter a valid email address',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'University',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 370,
                    child: DropdownButtonFormField2<String>(
                      alignment: Alignment.centerLeft,
                      hint: Text(
                        'Select your university',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Teachers-SB',
                          fontSize: 12,
                          color: Color(0xFF6D6D6D),
                        ),
                      ),
                      validator: (value) {
                        if (_selectedValue == null || _selectedValue!.isEmpty) {
                          return 'Please select the university';
                        }
                        return null;
                      },
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Teachers-SB',
                        fontSize: 12,
                        color: Color(0xFF6D6D6D),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFD9D9D9),
                        prefixIcon: Icon(
                          Icons.school,
                          color: Color(0xFF818181),
                          size: 20,
                        ),
                        errorStyle: TextStyle(
                          fontFamily: 'Teachers-R',
                          fontSize: 10,
                          color: Colors.red,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFB9B9B9),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFB9B9B9),
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      items:
                          mockUniversityList
                              .map(
                                (uni) => DropdownMenuItem(
                                  alignment: Alignment.centerLeft,
                                  value: uni,
                                  child: Text(uni),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        _selectedValue = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Major/Field of Study',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  reusableTextFormField(
                    hintText: 'e.g. Computer Science',
                    prefixIcon: Icons.menu_book_rounded,
                    errorText: 'Please enter your major/field of study',
                  ),
                  const SizedBox(height: 10),

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
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Confirm Passowrd',
                    style: TextStyle(
                      fontFamily: 'Teachers-SB',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // want to check condition if two text fields are the same or not
                  reusableTextFormFieldWithSuffixIcon(
                    hintText: 'Please enter your confirm password',
                    prefixIcon: Icons.lock,
                    obscureText: _obscureConfirmPassword,
                    toggleObscure: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your confirm password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    value: _isChecked,
                    onChanged: (newValue) {
                      setState(() {
                        _isChecked = newValue ?? false;
                      });
                    },
                    title: Text(
                      'I agree to the Terms of Services and Privacy Policy',
                      style: TextStyle(
                        fontFamily: 'Teachers-M',
                        fontSize: 12,
                        color: Color(0xFF6D6D6D),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    checkboxScaleFactor: 0.7,
                    checkColor: Color(0xFFB9B9B9),
                    activeColor: Color(0xFF6D6D6D),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (!_isChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.white,
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              content: Text(
                                'You must agree to our Terms and Conditions first',
                                style: TextStyle(
                                  fontFamily: 'Teachers-M',
                                  fontSize: 12,
                                  color: Color(0xFF6D6D6D),
                                ),
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            passwordController.clear();
                            confirmPasswordController.clear();
                            _formKey.currentState!.reset();
                          });
                        }
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
                          'Create Account',
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
                        'Already have an account? ',
                        style: TextStyle(
                          fontFamily: 'Teachers-M',
                          fontSize: 12,
                          color: Color(0xFF7C7C7C),
                        ),
                      ),
                      GestureDetector(
                        //to navigate to login screen
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
                            fontSize: 12,
                            color: Color(0xFF7B7B7B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
