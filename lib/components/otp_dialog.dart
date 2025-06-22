import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:ammentor/screen/auth/view/otp_verification.dart';

class OtpVerificationDialog extends StatelessWidget {
  final UserRole userRole;
  final String email;

  const OtpVerificationDialog({
    super.key,
    required this.userRole,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.06),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.035),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: OtpVerification(
                userRole: userRole,
                email: email,
              ),
            ),
          ),
        ),
      ),
    );
  }
}