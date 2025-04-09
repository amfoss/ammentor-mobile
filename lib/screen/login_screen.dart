import 'package:ammentor/screen/mentees/mentee_dashboard.dart';
import 'package:ammentor/screen/mentor/mentor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:ammentor/components/custom_text_field.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/welcome_screen.dart';
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
    final double fieldWidth = MediaQuery.of(context).size.width;
    final double fieldHeight = MediaQuery.of(context).size.height;

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
              top: 80,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 300,
                  width: 400,
                  child: Image.asset(
                    'assets/images/amMentor.png',
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    label: "Email",
                    hintText: "Enter your email",
                    width: fieldWidth * 0.8,
                  ),
                  SizedBox(height: fieldHeight * 0.02),
                  CustomTextField(
                    controller: passwordController,
                    label: "Password",
                    hintText: "Enter your password",
                    isPassword: true,
                    width: fieldWidth * 0.8,
                  ),
                  SizedBox(height: fieldHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      final Widget targetPage = widget.userRole == UserRole.mentor
                          ? const MentorHomePage()
                          : const MenteeHomePage();

                      Navigator.of(context).pushReplacement(
                        PageAnimationTransition(
                          page: targetPage,
                          pageAnimationType: BottomToTopFadedTransition(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}