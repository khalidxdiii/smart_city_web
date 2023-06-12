import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'admin_layout_screen_moudule.dart';
import 'web/admin_layout_web.dart';

class AdminLayoutScreen extends StatelessWidget {
  const AdminLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const AdminLayoutScreenMoudule(),
      desktop: const AdminLayoutScreenWeb(),
      
    );
    
  }
}