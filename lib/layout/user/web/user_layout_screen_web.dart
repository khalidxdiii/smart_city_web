import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../main.dart';
import '../../../shared/component/constants.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/styles/colors.dart';

class UserLayoutScreenWeb extends StatelessWidget {
  const UserLayoutScreenWeb({super.key});

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
                    Expanded(
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
                                   UserLayoutSideMenu(
                                    text: cubit.titles[0],
                                    icon: Icons.home,
                                    index: 0,
                                  ),
                                  UserLayoutSideMenu(
                                    text: cubit.titles[1],
                                    icon: Icons.camera_enhance,
                                    index: 1,
                                  ),
                                  UserLayoutSideMenu(
                                      text: cubit.titles[2],
                                      index: 2,
                                      icon: Icons.menu),
                                ],
                              ),
                            ),
                            const UserLayoutLogout(
                                text: 'تسجيل خروج', icon: Icons.logout),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          color: Colors.grey,
                          child: Scaffold(
                            appBar: AppBar(
                              title: Text(
                                cubit.titles[cubit.currentIndex],
                                style: GoogleFonts.almarai(color: Colors.white),
                              ),
                              centerTitle: true,
                              elevation: 0,
                            ),
                            body: cubit.screens.elementAt(cubit.currentIndex),
                          )),
                    ),
                  ],
                ),
              );
            }));
  }
}

class UserLayoutSideMenu extends StatelessWidget {
  const UserLayoutSideMenu(
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
              style: GoogleFonts.almarai(color: Colors.white),
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

class UserLayoutLogout extends StatelessWidget {
  const UserLayoutLogout({super.key, required this.text, required this.icon});
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
                style: GoogleFonts.almarai(),
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
