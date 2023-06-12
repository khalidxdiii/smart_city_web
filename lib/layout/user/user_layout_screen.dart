import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'user_layout_screen_module.dart';
import 'web/user_layout_screen_web.dart';


class UserLayoutScreen extends StatelessWidget {
  const UserLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const Scaffold(
        body: UserLayoutScreenModule(),
      ),
      desktop: const UserLayoutScreenWeb(),
    );
  }
}
