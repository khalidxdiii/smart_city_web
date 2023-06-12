import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/problem_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/component/admin_report_card_widget.dart';
import '../../../shared/component/skeliton.dart';
import '../../../shared/styles/colors.dart';
import 'open image/open_image.dart';
import 'report details/pinding_report_details_screen.dart';

MAUserModel? userCardWidgetData;
MAProblemModel? problemCardData;

class PindingReportScreen extends StatefulWidget {
  const PindingReportScreen({super.key});

  @override
  State<PindingReportScreen> createState() => _PindingReportScreenState();
}

class _PindingReportScreenState extends State<PindingReportScreen> {
  bool doneSelected = true;
  int? isSelected;
  @override
  Widget build(BuildContext context) {
    var refReport = FirebaseFirestore.instance
        .collection('problems')
        .where('report_state', isEqualTo: 'معلق')
        .orderBy('timestamp');

    return Scaffold(
      backgroundColor: Colors.grey[300],
      // body: StreamBuilder(
      //   stream: refReport.snapshots(),
      //   builder: (context, snapshot) {

      //     if (snapshot.hasError) {
      //       return Center(child: Text(snapshot.error.toString()));
      //     }
      body: FutureBuilder<QuerySnapshot>(
        // future: refReport.get(),
        future: FirebaseFirestore.instance
            .collection('problems')
            .where('report_state', isEqualTo: 'معلق')
            // .orderBy('timestamp')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
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
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('Loading');
            // return const Center(child: CircularProgressIndicator());
            return ListView.builder(itemCount: 10,itemBuilder: (context, index) => const Skeliton(height: 210,),);
          }

          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final problemModel = MAProblemModel.fromJSON(
                  snapshot.data!.docs[index].data() as Map,
                );

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
                      // return reportcard(problemModel, user, context);
                      // return ReportCardItem(
                      //   problemModel: problemModel,
                      //   userModel: user,
                      //   index: index,

                      // );
                      return Visibility(
                        visible: isSelected == index,
                        replacement: Visibility(
                          visible: doneSelected,
                          // child: ReportCardItem(
                          //     index, problemModel, user, context),
                          child:  AdminReportCardWidget(
                          index: index,
                          problemModel: problemModel,
                          userModel: user,
                          
                          
                          function: () {
                            userCardWidgetData = user;
        problemCardData = problemModel;
        setState(() {
          isSelected = index;
          doneSelected = false;
        });
                    
                          },
                        ),
                        ),
                        child: SizedBox(
                          width: 600,
                          height: 600,
                          child: PindingReportDetailsScreen(
                            user: user,
                            problem: problemModel,
                            index: index,
                          ),
                        ),
                      );
                    } else {
                      return const Text('');
                      // return const Center(
                      //   child: CircularProgressIndicator(),
                      // );
                    }
                  },
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget ReportCardItem(int index, MAProblemModel problemModel,
      MAUserModel userModel, BuildContext context) {
    return GestureDetector(
      onTap: () {
        userCardWidgetData = userModel;
        problemCardData = problemModel;
        setState(() {
          isSelected = index;
          doneSelected = false;
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, bottom: 2, top: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: kDprimaryColor,
              width: 2.0,
            ),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 15), blurRadius: 25, color: Colors.black12),
            ],
          ),
          //width: 420,
          height: 204,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.person,
                        color: kDprimaryColor,
                      ),
                    ),
                    Text(
                      userModel.fullName ?? 'no name',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.almarai(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: kDprimaryColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "رقم التقرير : ${problemModel.reportID!}",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.almarai(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            problemModel.title!,
                                            //'عنوان التقرير',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.almarai(
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            problemModel.disc!,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.almarai(
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            problemModel.prTime!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: GoogleFonts.almarai(
                                              fontSize: 12,
                                              // color: Colors.black,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.only(
                            top: 0, bottom: 0, left: 5, right: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: kDprimaryColor,
                            width: 2.0,
                          ),
                          //color: Colors.red,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return OpenImageScreen(
                                imageUrl: problemModel,
                                isImageAfter: false,
                              );
                            }));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              '${problemModel.imageUrl}',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
