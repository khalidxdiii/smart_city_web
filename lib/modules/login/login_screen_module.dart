import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../layout/admin/admin_layout_screen.dart';
import '../../layout/user/user_layout_screen.dart';
import '../../shared/component/componant.dart';
import '../../shared/component/constants.dart';
import '../../shared/styles/colors.dart';
import '../sign_up/sigup_screen.dart';

//mport 'dart:io' as device;

class LoginScreenModule extends StatefulWidget {
  const LoginScreenModule({super.key});

  @override
  State<LoginScreenModule> createState() => _LoginScreenModuleState();
}

final auth = FirebaseAuth.instance;
var formKey = GlobalKey<FormState>();
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

var emailController = TextEditingController();
var passwordController = TextEditingController();
bool isPasswordShow = true;
bool isLoading = false;

class _LoginScreenModuleState extends State<LoginScreenModule> {
  //bool isWeb = !(device.Platform.isAndroid || device.Platform.isIOS );
  @override
  Widget build(BuildContext context) {

    Future<void> checkAuthentication() async {
      
  if (formKey.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });
    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        isLoading = false;
      });
      User? user = auth.currentUser;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists && userDoc.get('role') == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'تم نسجيل الدخول بنجاح',
            style: GoogleFonts.almarai(),
          ),
          backgroundColor: kDprimaryColor,
        ));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const AdminLayoutScreen(),
          ),
          (route) => false,
        );
        emailController.clear();
        passwordController.clear();
        debugPrint('#####################');
        debugPrint(auth.currentUser!.email);
        debugPrint(auth.currentUser!.uid);
        debugPrint('#####################');

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'تم نسجيل الدخول بنجاح',
            style: GoogleFonts.almarai(),
          ),
          backgroundColor: kDprimaryColor,
        ));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const UserLayoutScreen(),
          ),
          (route) => false,
        );
      }
      emailController.clear();
      passwordController.clear();
      debugPrint('#####################');
      debugPrint(auth.currentUser!.email);
      debugPrint(auth.currentUser!.uid);
      debugPrint('#####################');
      
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        String failLogin = 'اسم المستخدم غير موجود';
        var snackBar = SnackBar(
          content: Text(
            failLogin,
            style: GoogleFonts.almarai(),
          ),
          backgroundColor: kDprimaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (e.code == 'wrong-password') {
        String failLogin = 'كلمه المرور غير صحيحه';
        var snackBar = SnackBar(
          content: Text(
            failLogin,
            style: GoogleFonts.almarai(),
          ),
          backgroundColor: kDprimaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      debugPrint(e.toString());
    }
  } else {
    String failLogin =
        'برجاء ادخال البريد الالكترونى وكلمه المرور بشكل صحيح';
    var snackBar = SnackBar(
      content: Text(
        failLogin,
        style: GoogleFonts.almarai(),
      ),
      backgroundColor: kDprimaryColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

    return Scaffold(
      key: scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  // height: 300,
                  decoration: const BoxDecoration(
                    // borderRadius: kIsWeb
                    //     ? const BorderRadius.only(
                    //         bottomLeft: Radius.circular(
                    //           30,
                    //         ),
                    //         bottomRight: Radius.circular(
                    //           30,
                    //         ),
                    //       )
                    //     : BorderRadius.circular(30),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                    color: kDprimaryColor,
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 5, right: 20, left: 20),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Image.asset(
                            kDAppImage,
                            height: 160,
                            width: 160,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            right: 0, top: 10, bottom: 20),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          //"        Login",
                          'تسجيل دخول',
                          style: GoogleFonts.almarai(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultTextFild(
                        controller: emailController,
                        label: 'البريد الالكترونى',
                        type: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يجب ألا يكون عنوان البريد الإلكتروني فارغًا';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DefaultTextFild(
                        controller: passwordController,
                        label: 'كلمه المرور',
                        type: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يجب ألا تكون كلمة المرور فارغة';
                          }
                          if (value.length < 6) {
                            return 'كلمه المرور لا يجب ان تقل عن 6 احرف';
                          }
                          return null;
                        },
                        IsPassword: isPasswordShow,
                        suffixIcon: isPasswordShow
                            ? Icons.visibility
                            : Icons.visibility_off,
                        suffixPressad: () {
                          setState(() {
                            isPasswordShow = !isPasswordShow;
                          });
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 0),
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Write Click Listener Code Here
                          },
                          child: const Text("نسيت كلمه المرور ؟"),
                          
                        ),
                      ),
                      DefaultButton(
                        text: 'تسجيل الدخول',
                        function: checkAuthentication,                
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ليس لديك حساب ؟  ",
                              style: GoogleFonts.almarai(),
                            ),
                            GestureDetector(
                              child: Text(
                                "سجل الان !!",
                                style: GoogleFonts.almarai(color: kDprimaryColor),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
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
    );
  }
}
