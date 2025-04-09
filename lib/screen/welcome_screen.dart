import 'package:ammentor/components/custom_button.dart';
import 'package:ammentor/components/theme.dart';

import 'package:ammentor/screen/login_screen.dart';

import 'package:flutter/material.dart';

import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

enum UserRole { mentee, mentor }

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
  
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _selectedOption = 'Mentor';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gradient.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Logo at Top
            Positioned(
              top: 100,
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

            // Dropdown + Continue Button
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),

                      CustomButton(
                        options: const ['Mentee', 'Mentor'],
                        initialSelection: 'Mentee',
                        onSelect: (selected) {
                          setState(() {
                            _selectedOption = selected;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageAnimationTransition(
                            
                              page: LoginScreen(userRole: _selectedOption == 'Mentor' ? UserRole.mentor : UserRole.mentee),
                              pageAnimationType: FadeAnimationTransition(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_circle_right_rounded),
                        color: AppColors.primary,
                        iconSize: 48,
                        tooltip: "Continue",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // amFOSS Bulb Logo at Bottom
            Positioned(
              bottom: -100,
              right: -100,
              child: Transform.rotate(
                angle: -0.5,
                child: Image.asset(
                  'assets/images/amfoss_bulb_white.png',
                  width: 450,
                  height: 450,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}