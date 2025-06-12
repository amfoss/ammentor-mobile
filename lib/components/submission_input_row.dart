// lib/components/submission_input_row.dart
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';

class SubmissionInputRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;

  const SubmissionInputRow({
    super.key,
    required this.icon,
    required this.text,
    this.controller,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.014,
          horizontal: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: controller != null
                  ? TextField(
                      controller: controller,
                      style: AppTextStyles.input(context).copyWith(
                        color: AppColors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: text,
                        hintStyle: AppTextStyles.input(context).copyWith(
                          color: AppColors.grey,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                      readOnly: readOnly,
                      onTap: onTap,
                      cursorColor: AppColors.primary,
                    )
                  : Text(
                      text,
                      style: AppTextStyles.body(context).copyWith(
                        color: AppColors.white,
                      ),
                    ),
            ),
            if (onTap != null)
              const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}