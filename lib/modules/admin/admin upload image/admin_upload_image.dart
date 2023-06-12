import 'package:flutter/material.dart';

import 'package:responsive_builder/responsive_builder.dart';
import '../../../models/problem_model.dart';
import 'admin_upload_image_mobile.dart';
import 'web/admin_upload_image_web.dart.dart';

class AdminUploadReport extends StatefulWidget {
  const AdminUploadReport({super.key, this.problem, });
final  MAProblemModel? problem;
  @override
  State<AdminUploadReport> createState() => _AdminUploadReportState();
}

class _AdminUploadReportState extends State<AdminUploadReport> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile:  AdminUploadImageMobile(problem: widget.problem),
      desktop:  AdminCameraScreenWeb(problem: widget.problem),
      
    );
  }
}
