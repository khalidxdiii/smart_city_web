import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'signup_screen_module.dart';
import 'web/signup_web.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const Scaffold(
        body: SignupscreenModule()
      ),
      desktop:const SignUpWebMoudule()
    );
  }
}
