import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'login_screen_module.dart';
import 'web/login_web.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const LoginScreenModule(),
      desktop: const LoginWebMoudule(),
      
    );
  }
}
