import 'package:flutter/material.dart';

Widget reusableTextFormField({
  required String hintText,
  required IconData prefixIcon,
  required String errorText,
  required TextEditingController controller
}) {
  return SizedBox(
    width: 370,
    child: TextFormField(
      controller: controller,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontFamily: 'Teachers-SB',
        fontSize: 12,
        color: Color(0xFF6D6D6D),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: Color(0xFF818181), size: 20),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
    ),
  );
}
