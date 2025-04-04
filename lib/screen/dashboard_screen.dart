import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: 
      Text('This is Dashabord',
      style: TextStyle(
        color: Colors.black
      ),),
    );
  }
}