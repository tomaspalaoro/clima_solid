import 'package:clima_solid/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
      iconSize: 20,
      onPressed:
          () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          ),
    );
  }
}
