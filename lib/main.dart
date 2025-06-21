import 'package:clima_solid/login_screen.dart';
import 'package:clima_solid/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginScreen(), theme: AppTheme.light);
  }
}
