import 'package:ammentor/components/otp_dialog.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:ammentor/screen/mentees/mentee_dashboard.dart';
import 'package:ammentor/screen/mentor/mentor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:ammentor/components/custom_text_field.dart';
import 'package:ammentor/components/theme.dart';
import 'package:page_animation_transition/animations/bottom_to_top_faded_transition.dart';

import 'package:page_animation_transition/page_animation_transition.dart';


class LoginScreen extends StatefulWidget {
  final UserRole userRole;

  const LoginScreen({super.key, required this.userRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gradient.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Logo
            Positioned(
              top: screenHeight*0.08,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: screenHeight*0.2,
                  width: screenWidth*0.8,
                  child: Image.asset(
                    'assets/images/image.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Login Form
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.userRole == UserRole.mentor ? "Mentor Login" : "Mentee Login",
                    style:  AppTextStyles.subheading(context).copyWith(
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  SizedBox(height: screenHeight*0.02),
                  CustomTextField(
                    controller: emailController,
                    label: "Email",
                    hintText: "Enter your email",
                    width: screenWidth * 0.8,
                  ),
                  SizedBox (height : screenHeight * 0.02),
                  
                  ElevatedButton(
                    onPressed: () {
                    showDialog(
                         context: context,
                          builder: (_) => OtpVerificationDialog(userRole: widget.userRole),
                        );
                      },
                      child: Text('Get OTP',
                      style: AppTextStyles.button(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary
                      ),
                    ),
                  )
                ],
              ),
            ),
                     
            Positioned(
              bottom: screenHeight*-0.08,
              right: screenHeight*-0.1,
              child: Transform.rotate(
                angle: -0.5,
                child: Image.asset(
                  'assets/images/amfoss_bulb_white.png',
                  width: screenWidth*0.95,
                  height: screenHeight*0.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}