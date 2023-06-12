import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/problem_model.dart';
import '../../../../models/user_model.dart';
import '../../../../shared/component/componant.dart';
import '../../../../shared/styles/colors.dart';
import '../open image/open_image.dart';
import '../user_rating_screen.dart';

class CompleteReportDetails extends StatefulWidget {
  const CompleteReportDetails({super.key, this.problem, this.user, this.index});
  final MAProblemModel? problem;
  final MAUserModel? user;
  final int? index;

  @override
  State<CompleteReportDetails> createState() => _CompleteReportDetailsState();
}

class _CompleteReportDetailsState extends State<CompleteReportDetails> {
  bool hideRattingScreen = true;
  @override
  Widget build(BuildContext context) {
    
    bool isUserRating = widget.problem?.isUserRating ?? true;
// isUserRating = !isUserRating;
    return Visibility(
      visible: hideRattingScreen,
     replacement: Visibility(
        child: UserRatingScrren(
          problem: widget.problem,
          user: widget.user,
        ),),
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'تفاصيل التقرير',
            style: GoogleFonts.almarai(),
          ),
        ),
        body: Padding(
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
                        text: widget.user!.phone!, icon: Icons.phone_iphone_outlined),
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
                    ReportCardDetailsWidget(
                        text: widget.problem!.title!, icon: Icons.list_alt),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'قبل',
                              style: GoogleFonts.almarai(
                                  color: kDprimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'بعد',
                              style: GoogleFonts.almarai(
                                  color: kDprimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return OpenImageScreen(
                                    imageUrl: widget.problem,
                                  );
                                }));
                              },
                              child: ReportDetailsImageCard(
                                imageUrl: widget.problem!.imageUrl,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return OpenImageScreen(
                                    imageUrl: widget.problem,
                                    isImageAfter: true,
                                  );
                                }));
                              },
                              child: ReportDetailsImageCard(
                               imageUrl: 'https://cors-anywhere.herokuapp.com/${widget.problem!.imageAfterUrl}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ReportCardDetailsWidget(
                        text: widget.problem!.selectedValue!, icon: Icons.list_alt),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        text: widget.problem!.prTime!, icon: Icons.calendar_month),
                    ReportCardDetailsWidget(
                        text: widget.problem!.adminEndReportTime!,
                        icon: Icons.calendar_month),
                    ReportCardDetailsWidget(
                        text: widget.problem!.disc!, icon: Icons.description_outlined),
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
                        '    تقييم المستخدم',
                        style: GoogleFonts.almarai(
                            color: kDprimaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //const SizedBox(height: 10,),
                    Visibility(
                      visible: isUserRating,
                      replacement: Column(
                        children: [
                          Center(
                            child: Text(
                              'المستحدم لم يضع تقيم للتقرير حتى الان!',
                              style: GoogleFonts.almarai(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: RatingBar.builder(
                              itemSize: 40,
                              initialRating: widget.problem!.rating ?? 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (_) {},
                              ignoreGestures: true,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReportCardDetailsWidget(
                              text: widget.problem!.userFeadback!, icon: Icons.task),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DefaultButton(
                              function: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => UserRatingScrren(
                                //             problem: problem,
                                //             user: user,
                                //           )),
                                // );
                                setState(() {
                                   hideRattingScreen = false;
                                });
                                
                              },
                              text: 'تفاصيل تقييم المستحدم',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
