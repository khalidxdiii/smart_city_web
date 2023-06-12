import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'user_upload_report_mobile.dart';
import 'web/user_upload_report_web.dart';



class UserUploadReport extends StatefulWidget {
  const UserUploadReport({super.key});

  @override
  State<UserUploadReport> createState() => _UserUploadReportState();
}

class _UserUploadReportState extends State<UserUploadReport> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const UserUploadReportMobile(),
      desktop: const UserUploadReportWeb(),
      
    );
  }
}
