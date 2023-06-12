import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/component/item_percentage_widget.dart';
import '../../../../shared/component/visualiztion_card_widget.dart';
import '../../../../shared/styles/colors.dart';

class AdminVisualizationScreen extends StatelessWidget {
  const AdminVisualizationScreen({super.key});

  Stream<QuerySnapshot> _getProblems() {
    return FirebaseFirestore.instance.collection('problems').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // final isMobile = screenWidth < 400;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          // const SizedBox(height: 5,),
          StreamBuilder<QuerySnapshot>(
            stream: _getProblems(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  int pending = 0;
                  int underReview = 0;
                  int completed = 0;

                  for (var doc in snapshot.data!.docs) {
                    String reportState = doc['report_state'];
                    if (reportState == 'معلق') {
                      pending++;
                    } else if (reportState == 'اكتمال') {
                      completed++;
                    } else if (reportState == 'قيد المراجعه') {
                      underReview++;
                    }
                  }

                  int total = pending + underReview + completed;
                  double pendingPercent = (pending / total) * 100;
                  double underReviewPercent = (underReview / total) * 100;
                  double completedPercent = (completed / total) * 100;
                  double radius = screenWidth * 0.1;
                  //  double radius = isMobile ? screenWidth * 0.1 : 80;
                  List<PieChartSectionData> sections = [
                    PieChartSectionData(
                      value: pending.toDouble(),
                      title: '${pendingPercent.toStringAsFixed(1)}%',
                      color: Colors.grey,
                      radius: radius,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: underReview.toDouble(),
                      title: '${underReviewPercent.toStringAsFixed(1)}%',
                      color: Colors.blue,
                      radius: radius,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: completed.toDouble(),
                      title: '${completedPercent.toStringAsFixed(1)}%',
                      color: Colors.green,
                      radius: radius,
                      titleStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            // height: screenHeight/1.41,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: kDprimaryColor,
                                width: 2.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 15),
                                    blurRadius: 25,
                                    color: Colors.black12),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'التفاصيل',
                                      style: GoogleFonts.almarai(
                                          color: kDprimaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ItemPercentageWedget(
                                        text1: 'اجمالى التقارير : ',
                                        text2: total.toString(),
                                        
                                      ),
                                      ItemPercentageWedget(
                                          text1: 'التقارير المعلقة : ',
                                          text2:
                                             total!=0? '$pending  (${pendingPercent.toStringAsFixed(1)}%)':pending.toString(),
                                             ),
                                      ItemPercentageWedget(
                                          text1: 'التقارير قيد المراجعه : ',
                                          text2:
                                             total!=0? '$underReview  (${underReviewPercent.toStringAsFixed(1)}%)':underReview.toString(),
                                              ),
                                      ItemPercentageWedget(
                                          text1: 'التقارير المكتمله : ',
                                          text2:
                                             total!=0? '$completed  (${completedPercent.toStringAsFixed(1)}%)':completed.toString(),
                                              ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: kDprimaryColor,
                                width: 2.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 15),
                                    blurRadius: 25,
                                    color: Colors.black12),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Center(
                                  child: Text(
                                    'احصائيات',
                                    style: GoogleFonts.almarai(
                                        color: kDprimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                VisualizationCardWidget(
                                  total: total,
                                  sections: sections,
                                  radius: radius,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
