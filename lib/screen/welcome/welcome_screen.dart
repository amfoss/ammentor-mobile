import 'package:ammentor/components/custom_button.dart';
import 'package:ammentor/components/theme.dart';

import 'package:ammentor/screen/auth/view/login_screen.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
              top: screenHeight*0.1,
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

            // Dropdown + Continue Button
            SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenHeight*0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight*0.02),

                      CustomButton(
                        options: const ['Mentee', 'Mentor'],
                        initialSelection: 'Mentee',
                        onSelect: (selected) {
                          setState(() {
                            _selectedOption = selected;
                          });
                        },
                      ),

                     SizedBox(height: screenHeight*0.02),

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
              bottom: screenHeight*-0.08,
              right: screenHeight*-0.08,
              child: Transform.rotate(
                angle: -0.5,
                child: Image.asset(
                  'assets/images/amfoss_bulb_white.png',
                  width: screenWidth*0.95,
                  height: screenHeight*0.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}