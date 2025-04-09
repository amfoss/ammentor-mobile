import 'package:ammentor/screen/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'components/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'amMentor',
      theme: appTheme,
      home: WelcomeScreen(),
    );
  }
}