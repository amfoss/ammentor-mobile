import 'package:ammentor/components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'leaderboard_screen.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const testUsers = {
    'test@user.com': 'password123',
    'admin@mentor.com': 'adminpass',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.grey, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Theme(
        data: appTheme, 
        child: FlutterLogin(
          logo: const AssetImage('assets/images/amMentor.png'),
          logoTag: 'logo',

          onLogin: (LoginData data) async {
            await Future.delayed(const Duration(milliseconds: 500));
            if (!testUsers.containsKey(data.name)) {
              return 'User not found';
            }
            if (testUsers[data.name] != data.password) {
              return 'Incorrect password';
            }
            return null;
          },
          onSignup: (SignupData data) async {
            await Future.delayed(const Duration(milliseconds: 500));
            if (testUsers.containsKey(data.name)) {
              return 'User already exists';
            }
            return null;
          },
          onRecoverPassword: (_) => Future.value(null),
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            );
          },

          theme: LoginTheme(
            primaryColor: Colors.transparent,
            accentColor: AppColors.primary,
            errorColor: AppColors.red,
            textFieldStyle: const TextStyle(color: AppColors.white),
            buttonStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            switchAuthTextColor: AppColors.white,
            bodyStyle: const TextStyle(color: AppColors.white),
            inputTheme: inputDecorationTheme,
            buttonTheme: const LoginButtonTheme(
              backgroundColor: AppColors.primary,
              splashColor: Colors.orangeAccent,
              highlightColor: Colors.amber,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
            cardTheme: const CardTheme(
              color: AppColors.surface,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}