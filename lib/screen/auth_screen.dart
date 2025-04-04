import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

static const testUsers = {
  'test@user.com': 'password123',
  'admin@mentor.com': 'adminpass',
};
  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      floatingLabelStyle: const TextStyle(color: Colors.white),
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIconColor: Colors.yellow,
      suffixIconColor: Colors.yellow,
      iconColor: Colors.yellow,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white70),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.yellow, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Theme(
        data: ThemeData.dark().copyWith(
          inputDecorationTheme: inputDecorationTheme,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
          ),
        ),
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
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          },
          theme: LoginTheme(
            primaryColor: Colors.transparent,
            accentColor: Colors.yellow,
            errorColor: Colors.redAccent,
            textFieldStyle: const TextStyle(color: Colors.white),
            buttonStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            switchAuthTextColor: Colors.white,
            bodyStyle: const TextStyle(color: Colors.white),

            inputTheme: inputDecorationTheme,

            // Button style
            buttonTheme: const LoginButtonTheme(
              backgroundColor: Color(0xFFF6C32E),
              splashColor: Colors.orangeAccent,
              highlightColor: Colors.amber,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),

            // Dialog box style
            cardTheme: const CardTheme(
              color: Color(0xFF2E2E2E),
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