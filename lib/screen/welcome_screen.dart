import 'package:cms/components/custom_button.dart';
import 'package:cms/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

//___________________________________________________________________________________________________________________________________
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _selectedOption = 'Mentor';
  bool showLogo = false;

  @override
  void initState() {
    super.initState();
  }

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
//_______________________________________________________________________________________________________

        child: Stack(
          children: [
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

//_______________________________________________________________________________________________________
SafeArea(
  child: Center(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),

          // Dropdown
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

          // Arrow Button
          IconButton(
            onPressed: () {
              if (_selectedOption == 'Mentee') {
                Navigator.of(context).push(
                  PageAnimationTransition(
                    page: const AuthScreen(),
                    pageAnimationType: FadeAnimationTransition(),
                  ),
                );
              } else if (_selectedOption == 'Mentor') {
                Navigator.of(context).push(
                  PageAnimationTransition(
                    page: const AuthScreen(), 
                    pageAnimationType: FadeAnimationTransition(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_circle_right_rounded),
            color: const Color(0xFFF6C32E),
            iconSize: 48,
            tooltip: "Continue",
          ),
        ],
      ),
    ),
  ),
),
//_______________________________________________________________________________________________________
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
