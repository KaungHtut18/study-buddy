import 'package:flutter/material.dart';

Widget reusableTextFormFieldWithSuffixIcon({
  required String hintText,
  required IconData prefixIcon,
  required TextEditingController controller,
  required bool obscureText,
  required VoidCallback toggleObscure,
  String? Function(String?)? validator,
}) {
  return SizedBox(
    width: 370,
    child: TextFormField(
      style: TextStyle(
        fontFamily: 'Teachers-SB',
        fontSize: 12,
        color: Color(0xFF6D6D6D),
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: Color(0xFF818181), size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF818181),
            size: 20,
          ),
          onPressed: toggleObscure,
        ),
        errorStyle: TextStyle(
          fontFamily: 'Teachers-R',
          fontSize: 10,
          color: Colors.red,
        ),
        hintText: hintText,
        filled: true,
        fillColor: Color(0xFFD9D9D9),
        hintStyle: TextStyle(
          fontFamily: 'Teachers-SB',
          fontSize: 12,
          color: Color(0xFF6D6D6D),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFB9B9B9), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFB9B9B9), width: 1.5),
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
      validator: validator,
      controller: controller,
    ),
  );
}