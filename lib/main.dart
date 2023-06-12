import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'layout/admin/admin_layout_screen.dart';
import 'layout/user/user_layout_screen.dart';
import 'modules/login/login_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/component/constants.dart';
import 'shared/styles/colors.dart';

Future<void> main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fb = FirebaseAuth.instance.currentUser;
  if (fb != null) {
    final bool? isAdmin = (await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get())["role"];

    runApp(MyApp(
      isAdmin: isAdmin ?? false,
    ));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.isAdmin = true}) : super(key: key);
  final bool? isAdmin;
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseAuth.instance.currentUser;
    bool auth = false;
    late Widget goWidget;
    if (fb != null) {
      goWidget =
          isAdmin! ? const AdminLayoutScreen() : const UserLayoutScreen();
      auth = true;
    }
    return MaterialApp(
      title: kDAppName,
      theme: ThemeData(
        primarySwatch: myColorSwatch,
        fontFamily: 'Almarai',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontSize: 20,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.normal,
              ),
              headlineSmall: const TextStyle(
                fontSize: 26,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.bold,
                color: kDprimaryColor,
              ),
            ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar", "EG"),
        Locale('en'),
      ],
      locale: const Locale("ar", "EG"),
     
     home: auth ? goWidget : const LoginScreen(),
    );
  }
}
