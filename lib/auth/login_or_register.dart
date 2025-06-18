import 'package:flutter/material.dart';
import 'package:skinswift/auth/login_screen.dart';
import 'package:skinswift/auth/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  final String skinType;
  final List<String> skinConcerns;

  const LoginOrRegister({
    super.key,
    required this.skinType,
    required this.skinConcerns,
  });

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Initially, show the login screen
  bool showLoginPage = true;

  // Toggle between login and register pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(onSwitchToRegister: togglePages);
    } else {
      return RegisterScreen(
        onSwitchToLogin: togglePages,
        skinType: widget.skinType,
        skinConcerns: widget.skinConcerns,
      );
    }
  }
} 