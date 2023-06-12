import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/problem_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/component/skeliton.dart';
import '../../../shared/component/user_report_card_widget.dart';
import '../../../shared/styles/colors.dart';
import 'report details/complete_report_details.dart';
import 'open image/open_image.dart';

MAUserModel? userCardWidgetData;
MAProblemModel? problemCardData;

class CompleteReport extends StatefulWidget {
  const CompleteReport({super.key});

  @override
  State<CompleteReport> createState() => _CompleteReportState();
}

class _CompleteReportState extends State<CompleteReport> {
  bool hideCompleteDetilsScreen = true;
  int? isSelected;

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<List<MAProblemModel>>(
        future: (FirebaseFirestore.instance
                .collection('problems')
                .where('user_id', isEqualTo: fb!.uid)
                .where('report_state', isEqualTo: 'اكتمال')
                .get())
            .then((value) => value.docs.map((doc) {
                  return MAProblemModel.fromJSON(doc.data());
                }).toList()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('Loading');
            // return const Center(child: CircularProgressIndicator());
            return ListView.builder(itemCount: 10,itemBuilder: (context, index) => const Skeliton(height: 170,),);
            
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'لا يوجد تقارير',
                style: GoogleFonts.almarai(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          }
          if (snapshot.data!.isEmpty) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  'لا يوجد تقارير',
                  style: GoogleFonts.almarai(
                      color: kDprimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
              ),
            );
          } else {
            if (snapshot.hasData) {
              // final problemModel2 = MAProblemModel.fromJSON(
              //     snapshot.data!.docs as Map, snapshot.data!.dat as String);
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // final problemModel = MAProblemModel.fromJSON(
                  //     snapshot.data!.data()[index] as Map,
                  //    );
                  final problemModel = snapshot.data![index];

                  return FutureBuilder(
                    future: (FirebaseFirestore.instance
                        .collection('users')
                        .doc(problemModel.uID)
                        .get()),
                    builder: (context, fusnap) {
                      if (fusnap.connectionState == ConnectionState.waiting) {
                        //return const Center(child: CircularProgressIndicator());
                      }

                      if (fusnap.hasData) {
                        final user =
                            MAUserModel.fromJSON(fusnap.data?.data() as Map);
                        return Visibility(
                          visible: isSelected == index,
                          replacement: Visibility(
                            visible: hideCompleteDetilsScreen,
                            child: UserReportCardWidget(
                          index: index,
                          problemModel: problemModel,
                          userModel: user,
                          showRaitingBar: true,
                          isImageAfter: true,
                          showTimeAfterSolve: true,
                          
                          function: () {
                           userCardWidgetData = user;
        problemCardData = problemModel;
        setState(() {
          isSelected = index;
          hideCompleteDetilsScreen = false;
        });
                          },
                        ),
                          ),
                          child: SizedBox(
                            width: 600,
                            height: 600,
                            // child: CompleteReportDetails(
                            //   user: user,
                            //   problem: mp,
                            //   index: index,
                            //   goBackButton: hideCompleteDetilsScreen,
                            // ),
                            child: UserReportCardWidget(
                          index: index,
                          problemModel: problemModel,
                          userModel: user,
                          showRaitingBar: true,
                          isImageAfter: true,
                          showTimeAfterSolve: true,
                          
                          function: () {
                           userCardWidgetData = user;
        problemCardData = problemModel;
        setState(() {
          isSelected = index;
          hideCompleteDetilsScreen = false;
        });
                          },
                        ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            '',
                            style: GoogleFonts.almarai(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

 
}
