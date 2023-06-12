import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/problem_model.dart';
import '../../../../models/user_model.dart';
import '../../../../shared/component/componant.dart';
import '../../../../shared/styles/colors.dart';
import '../../admin upload image/admin_upload_image.dart';
import '../open image/open_image.dart';

class UnderReviewReportDetails extends StatefulWidget {
  const UnderReviewReportDetails(
      {super.key, this.problem, this.user, this.index});
  final MAProblemModel? problem;
  final MAUserModel? user;
  final int? index;

  @override
  State<UnderReviewReportDetails> createState() =>
      _UnderReviewReportDetailsState();
}

class _UnderReviewReportDetailsState extends State<UnderReviewReportDetails> {
  bool hideUploadCameraScreen = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'تفاصيل التقرير',
          style: GoogleFonts.almarai(),
        ),
      ),
      body: Visibility(
        visible: hideUploadCameraScreen,
        replacement: AdminUploadReport(
          problem: widget.problem,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '    بيانات المستخدم',
                        style: GoogleFonts.almarai(
                            color: kDprimaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ReportCardDetailsWidget(
                        text: widget.user!.fullName!,
                        icon: Icons.person_outline,
                        fontWeight: FontWeight.bold),
                    ReportCardDetailsWidget(
                        text: widget.user!.phone!,
                        icon: Icons.phone_iphone_outlined),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '    بيانات التقرير',
                        style: GoogleFonts.almarai(
                            color: kDprimaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ReportCardDetailsWidget(
                        text: 'رقم التقرير : ${widget.problem!.reportID!}',
                        icon: Icons.list_alt),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return OpenImageScreen(
                            imageUrl: widget.problem,
                          );
                        }));
                      },
                      child: Hero(
                        tag: 'imageHero',
                        child: ReportDetailsImageCard(
                          imageUrl: 'https://cors-anywhere.herokuapp.com/${widget.problem!.imageUrl}',
                        ),
                      ),
                    ),
                    ReportCardDetailsWidget(
                        text: widget.problem!.title!, icon: Icons.list_alt),
                    ReportCardDetailsWidget(
                        text: widget.problem!.selectedValue!,
                        icon: Icons.list_alt),
                    GestureDetector(
                      onTap: () async {
                        final String googleMapsUrl =
                            'https://www.google.com/maps/search/?api=1&query=${widget.problem!.latitude!},${widget.problem!.longitude!}';
                        if (await canLaunch(googleMapsUrl)) {
                          await launch(googleMapsUrl);
                        } else {
                          throw 'Could not open Google Maps';
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'اضغط لعرض الموقع',
                              style: GoogleFonts.almarai(
                                  color: kDprimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                         const SizedBox(
                            height: 10,
                          ),
                          ReportCardDetailsWidget(
                              text: widget.problem!.locationDisc!,
                              icon: Icons.explore_outlined),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReportCardDetailsWidget(
                        text: widget.problem!.prTime!,
                        icon: Icons.calendar_month),
                    ReportCardDetailsWidget(
                        text: widget.problem!.disc!,
                        icon: Icons.description_outlined),
                    ReportCardDetailsWidget(
                        text: widget.problem!.adminNotice!, icon: Icons.task),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DefaultButton(
                        text: 'تحديث البيانات',
                        function: () {
                          setState(() {
                            hideUploadCameraScreen = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
