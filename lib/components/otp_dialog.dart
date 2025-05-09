import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:ammentor/screen/auth/view/otp_verification.dart';
import 'package:flutter/material.dart';

class OtpVerificationDialog extends StatelessWidget {
  final UserRole userRole;

  const OtpVerificationDialog({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(56)),
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth*0.01, vertical: screenHeight*0.026),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(screenHeight*0.026),
        child: IntrinsicHeight(
          child: OtpVerification(
            userRole: userRole, 
          ),
        ),
      ),
    );
  }
}