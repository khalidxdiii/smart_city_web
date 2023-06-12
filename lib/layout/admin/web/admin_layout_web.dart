import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../../main.dart';
import '../../../modules/admin/report/search/search_screen.dart';
import '../../../shared/component/constants.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/styles/colors.dart';

class AdminLayoutScreenWeb extends StatelessWidget {
  const AdminLayoutScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
   
    return BlocProvider(
        create: (BuildContext context) => AppCubit(),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (BuildContext context, AppStates state) {},
            builder: (BuildContext context, AppStates state) {
              AppCubit cubit = AppCubit.get(context);
              return Scaffold(
                body: Row(
                  children: [
                    Visibility(
                      visible: cubit.clicksearch,
                      // replacement: ,
                      child: Expanded(
                        child: Container(
                          color: kDsecondaryColor,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                color: kDprimaryColor,
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  kDAppImage,
                                  height: 160,
                                  width: 160,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    AdminLayoutSideMenu(
                                      text: cubit.adminTitles[0],
                                      icon: Icons.home,
                                      index: 0,
                                    ),
                                    AdminLayoutSideMenu(
                                      text: cubit.adminTitles[1],
                                      icon: Icons.toc,
                                      index: 1,
                                    ),
                                    // AdminLayoutSideMenu(
                                    //     text:  cubit.adminTitles[2],
                                    //     index: 2,
                                    //     icon: Icons.business_center),
                                    // AdminLayoutSideMenu(
                                    //     text:  cubit.adminTitles[3],
                                    //     index: 3,
                                    //     icon: Icons.playlist_add_check),
                                    //AdminSideMenuExcel(text: 'تصدير ملف feedback',icon: Icons.task,)
                                  ],
                                ),
                              ),
                              const AdminLayoutLogout(
                                  text: 'تسجيل خروج', icon: Icons.logout),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 2,child: MainViewLayoutWidget(cubit: cubit)),
                  ],
                ),
              );
            }));
  }
}

class MainViewLayoutWidget extends StatelessWidget {
  const MainViewLayoutWidget({
    super.key,
    required this.cubit,
  });

  final AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: cubit.clicksearch,
      replacement:  SearchScreen(showsearchvalue: cubit.clicksearch),
      
      child: Container(
          color: kDsecondaryColor,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    cubit.showsearch();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         const SearchScreen(),
                    //   ),
                    // );
                  },
                )
              ],
              title: Text(
                cubit.adminTitles[cubit.currentIndex],
                style: GoogleFonts.almarai(
                    color: kDsecondaryColor),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: cubit.adminScreens
                .elementAt(cubit.currentIndex),
          )),
    );
  }
}

class AdminLayoutSideMenu extends StatelessWidget {
  const AdminLayoutSideMenu(
      {super.key, required this.text, required this.icon, required this.index});
  final String text;
  final int index;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            AppCubit.get(context).changeIndex(index);
          },
          child: ListTile(
            title: Text(
              text,
              style: GoogleFonts.almarai(color: kDsecondaryColor),
            ),
            leading: Icon(
              icon,
              color: Colors.white,
            ),
            tileColor: kDprimaryColor,
          ),
        ),
        Container(
          height: 1,
          color: Colors.white,
        ),
      ],
    );
  }
}

class AdminLayoutLogout extends StatelessWidget {
  const AdminLayoutLogout({super.key, required this.text, required this.icon});
  final String text;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              // Sign-out successful.
            }).catchError((error) {
              debugPrint(error.ToString());
            });

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
                (route) => false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'تم تسجيل الخروج بنجاح !',
                style: GoogleFonts.almarai(color: kDsecondaryColor),
              ),
              backgroundColor: kDprimaryColor,
            ));
          },
          child: ListTile(
            title: Text(
              text,
              style: GoogleFonts.almarai(color: Colors.white),
            ),
            leading: Icon(
              icon,
              color: Colors.white,
            ),
            tileColor: kDprimaryColor,
          ),
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }
}

class AdminSideMenuExcel extends StatelessWidget {
  const AdminSideMenuExcel({
    super.key,
    required this.text,
    required this.icon,
  });
  final String text;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              // Request storage permission
              final status = await Permission.storage.request();
              if (!status.isGranted) {
                debugPrint('Permission denied. Cannot save file.');
                return;
              }

              // Fetch data from Firestore
              final firestore = FirebaseFirestore.instance;
              final feedbackSnapshot =
                  await firestore.collection('feedback').get();

              // Create a new Excel file
              final excel = Excel.createExcel();

              // Add a sheet and set headers
              final sheet = excel['feedback'];
              sheet.insertRowIterables([
                'reportID',
                'ما رايك بالخدمه بشكل عام',
                'ما مدى رضاك عن حل المشكله',
                'سرعه الاستجابه فى حل المشكله',
                'ما رايك فى التعامل مع المسؤلين مع المشكله',
                'ما رايك فى تعامل المسؤلين معك بشكل خاص',
                'تقييم المسؤلين بشكل عام',
                'هل تنصح اصدقائك باستخدام التطبيق',
                'تعامل ممثل خدمة العملاء مع مكالمتي بسرعة',
                'كان ممثل خدمة العملاء مهذبًا للغاية',
                'كان ممثل خدمة العملاء على دراية كبيرة بالمشكله',
                'user_feadback',
              ], 0);

              // Insert data
              int rowIndex = 1;
              for (var doc in feedbackSnapshot.docs) {
                final data = doc.data();
                sheet.insertRowIterables([
                  doc.id,
                  data['reportID'],
                  data['ما رايك بالخدمه بشكل عام'],
                  data['ما مدى رضاك عن حل المشكله'],
                  data['سرعه الاستجابه فى حل المشكله'],
                  data['ما رايك فى التعامل مع المسؤلين مع المشكله'],
                  data['ما رايك فى تعامل المسؤلين معك بشكل خاص'],
                  data['تقييم المسؤلين بشكل عام'],
                  data['هل تنصح اصدقائك باستخدام التطبيق'],
                  data['تعامل ممثل خدمة العملاء مع مكالمتي بسرعة'],
                  data['كان ممثل خدمة العملاء مهذبًا للغاية'],
                  data['كان ممثل خدمة العملاء على دراية كبيرة بالمشكله'],
                  data['user_feadback'],
                  // data['user_rating_time'].toDate().toString(),
                ], rowIndex++);
              }

              // Save the file to the device storage
              final directory = await getExternalStorageDirectory();
              final filePath = '${directory!.path}/feedback.xlsx';
              final excelData = excel.encode();
              final file = File(filePath);
              await file.create(recursive: true);
              await file.writeAsBytes(excelData!);
              debugPrint('#################');
              debugPrint('File saved at $filePath');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'تم حفظ الملف',
                  style: GoogleFonts.almarai(),
                ),
                backgroundColor: kDprimaryColor,
              ));
            } catch (e) {
              debugPrint('#################');
              debugPrint(e.toString());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  e.toString(),
                  style: GoogleFonts.almarai(),
                ),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: ListTile(
            title: Text(
              text,
              style: GoogleFonts.almarai(color: Colors.white),
            ),
            leading: Icon(
              icon,
              color: Colors.white,
            ),
            tileColor: kDprimaryColor,
          ),
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }
}
