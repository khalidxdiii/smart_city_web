import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/problem_model.dart';
import '../../../models/user_model.dart';

import '../../../shared/component/admin_report_card_widget.dart';
import '../../../shared/component/skeliton.dart';
import '../../../shared/styles/colors.dart';
import 'report details/complete_report_details.dart';
import 'open image/open_image.dart';

// var isSelected;
 MAUserModel? userCardWidgetData;
MAProblemModel? problemCardData;


class CompleteReport extends StatefulWidget {
  const CompleteReport({super.key});

  @override
  State<CompleteReport> createState() => _CompleteReportState();
}

class _CompleteReportState extends State<CompleteReport> {
  // bool isSelected = true;
  bool doneSelected = true;
  int? isSelected;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<List<MAProblemModel>>(
        future: (FirebaseFirestore.instance
                .collection('problems')
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
            return ListView.builder(itemCount: 10,itemBuilder: (context, index) => const Skeliton(height: 210,),);
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
                            visible: doneSelected,
                            // replacement: const Text(''),
                            // child: reportcard(index, mp, user, context)));
                            // child: ReportCardWidget(
                            //   index: index,
                            //   problemModel: mp,
                            //   userModel: user,isSelected: isSelected,doneSelected: doneSelected,
                            // ),
                            // child: reportcard(index, mp, user, context),

                            child:AdminReportCardWidget(
                          index: index,
                          problemModel: problemModel,
                          userModel: user,
                          isImageAfter: true,
                          showRaitingBar: true,
                          showTimeAfterSolve: true,
                          function: () {
                            userCardWidgetData = user;
        problemCardData = problemModel;
        setState(() {
          isSelected = index;
          doneSelected = false;
        });
                          },
                        ) ,
                          ),
                          child: SizedBox(
                            width: 600,
                            height: 600,
                            child: CompleteReportDetails(
                              user: userCardWidgetData,
                              problem: problemCardData,
                              index: index,
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

  Widget reportcard(int index, MAProblemModel problemModel,
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
          height: 220,
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
                                      height: 130,
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
                                            maxLines: 3,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),

                                          Text(
                                            problemModel.adminEndReportTime!,
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
                                          RatingBar.builder(
                                            itemSize: 30,
                                            initialRating:
                                                problemModel.rating ?? 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 1.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (_) {},
                                            ignoreGestures: true,
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Text('ملاحظات : ',
                                          //         style: GoogleFonts.almarai()),
                                          //     Expanded(
                                          //       child: Text(
                                          //         problemModel.adminNotice!,
                                          //         maxLines: 1,
                                          //         overflow: TextOverflow.ellipsis,
                                          //         style: GoogleFonts.almarai(
                                          //           color: kDprimaryColor,
                                          //           fontWeight: FontWeight.bold,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
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
                                isImageAfter: true,
                              );
                            }));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              '${problemModel.imageAfterUrl}',
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

