// custom_text_field.dart
import 'package:flutter/material.dart';
import 'theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final double? width;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: AppTextStyles.input(context), 
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: AppTextStyles.input(
            context,
          ).copyWith(color: AppColors.border), 
          labelStyle: AppTextStyles.label(context), 
          contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.05,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(width: 1, color: AppColors.border),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(width: 1, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
