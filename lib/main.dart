import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_theme.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/auth/presentation/pages/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      title: 'App',
      home: SignupScreen(),
    );
  }
}