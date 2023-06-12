import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../layout/user/user_layout_screen.dart';
import '../../../shared/component/componant.dart';
import '../../../shared/component/constants.dart';
import '../../../shared/styles/colors.dart';
import 'package:http/http.dart' as http;




class SignUpWebMoudule extends StatefulWidget {
  const SignUpWebMoudule({super.key});

  @override
  State<SignUpWebMoudule> createState() => _SignUpWebMouduleState();
}
final auth = FirebaseAuth.instance;
var formKey = GlobalKey<FormState>();
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

bool isLoading = false;
 
  late String uID;

  
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var nationalIDController = TextEditingController();
  var addressController = TextEditingController();
  var dateOfBirthController = TextEditingController();

  bool isPasswordShow = true;

class _SignUpWebMouduleState extends State<SignUpWebMoudule> {
  @override
  Widget build(BuildContext context) {

   Future<void> register() async {
      if (formKey.currentState!.validate()) {
        String acssesLogin = 'تم انشاء الحساب بنجاح';

        var snackBar = SnackBar(
          content: Text(
            acssesLogin,
            style: GoogleFonts.almarai(),
          ),
          backgroundColor: kDprimaryColor,
        );
        setState(() {
          isLoading = true;
        });
        try {
          await auth.createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
          uID = auth.currentUser!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uID).set({
            'full name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
            'phone': phoneController.text.trim(),
            'national ID': nationalIDController.text.trim(),
            'address': addressController.text.trim(),
            'date Of Birth': dateOfBirthController.text.trim(),
            'register date time': Timestamp.now(),
            'role': false,
          });

        //////////////////  Send Email ///////////////////////////////
       


       
        ////////////////////////////////////////////////////
          // .then((value) => debugPrint('ok'))
          // .catchError((error) => debugPrint(error.toString()));
          debugPrint(auth.currentUser!.email);
          debugPrint(auth.currentUser!.uid);
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UserLayoutScreen(),
              ),
              (route) => false);
        } on FirebaseAuthException catch (e) {
          var snackBar = SnackBar(
            content: Text(
              e.toString(),
              style: GoogleFonts.almarai(),
            ),
            backgroundColor: kDprimaryColor,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          debugPrint(e.code.toString());
        }
      } else {
        String failLogin = 'برجاء ملئ البيانات بشكل صحيح';
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
    
    // Future sendemail()async{
    //                 // Set up SMTP server configuration
    //           final smtpServer = gmail('fokkakmeni@gmail.com', '506040202013');

    //           // Create email message
    //           final message = Message()
    //             ..from = const Address('fokkakmeni@gmail.com', kDAppName)
    //             ..recipients.add(emailController.text.trim())
    //             //..ccRecipients.addAll(['recipient2@example.com', 'recipient3@example.com'])
    //             ..subject = '${kDAppName} - registration successful'
    //             // ..text = registrationSuccessMessage;
    //             ..html = '<h1>Hi ,</h1>\n<p>Your registration was successful.</p>';

    //           // Send email
    //           try {
    //             final sendReport = await send(message, smtpServer);
    //             debugPrint('Message sent: ${sendReport.toString()}');
    //           } on MailerException catch (e) {
    //             debugPrint('Message not sent. ${e.toString()}');
    //           } catch (e) {
    //             debugPrint('An unexpected error occurred. ${e.toString()}');
    //           }

    // }

// Future sendemail()async{
//                     // Set up SMTP server configuration
//               // final smtpServer = gmail('fokkakmeni@gmail.com', '506040202013');
//               final smtpServer = SmtpServer('smtp.sendgrid.net',
//       port: 465,ssl: true,
//       username: 'apikey',
//       password: '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');

//               // Create email message
//               final message = Message()
//                 ..from = const Address('fokkakmeni@gmail.com', kDAppName)
//                 ..recipients.add(emailController.text)
//                 //..ccRecipients.addAll(['recipient2@example.com', 'recipient3@example.com'])
//                 ..subject = '$kDAppName - registration successful'
//                 ..text = registrationSuccessMessage;
//                 // ..html = '<h1>Hi ,</h1>\n<p>Your registration was successful.</p>';

//               // Send email
//               try {
//                 final sendReport = await send(message, smtpServer);
//                 debugPrint('Message sent: ${sendReport.toString()}');
//               } on MailerException catch (e) {
//                 debugPrint('Message not sent. ${e.toString()}');
//               } catch (e) {
//                 debugPrint('An unexpected error occurred. ${e.toString()}');
//               }

//     }

// Future<void> sendRegistrationSuccessEmail() async {
//   final smtpServer = gmail('fokkakmeni@gmail.com', '506040202013');

//   final message = Message()
//     ..from = const Address('fokkakmeni@gmail.com', kDAppName)
//     ..recipients.add(emailController.text.trim())
//     ..subject = '$kDAppName - registration successful'
//     ..text = registrationSuccessMessage;

//   try {
//     final sendReport = await send(message, smtpServer);
//     debugPrint('Message sent: ${sendReport.toString()}');
//   } on MailerException catch (e) {
//     debugPrint('Message not sent. ${e.toString()}');
//   } catch (e) {
//     debugPrint('An unexpected error occurred. ${e.toString()}');
//   }
// }

// void sendEmail() async {
//   final Email email = Email(
//     body: 'Hello,\n\nYour registration was successful.',
//     subject: 'Registration Successful',
//     recipients: ['recipient@example.com'],
//     isHTML: false,
//   );
  
//   try {
//     await FlutterEmailSender.send(email);
//     print('Email sent successfully');
//   } catch (e) {
//     print('Error sending email: $e');
//   }
// }

// Future<void> sendEmailBySendGrid() async {
//   final sendgrid = Mailer('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');
//   final mail = Mail(
//     from: Email('from@example.com'),
//     to: [
//       Email('to1@example.com'),
//       Email('to2@example.com'),
//     ],
//     subject: 'Subject',
//     content: [
//       Content('text/plain', 'Hello World!'),
//       Content('text/html', '<p>Hello World!</p>'),
//     ],
//   );
//   final response = await sendgrid.send(mail);
//   print(response.statusCode);
//   print(response.body);
// }

//  sendEmail()  {
//   final smtpServer = SmtpServer('smtp.sendgrid.net',
//       port: 465,
//       username: 'apikey',
//       password: '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');

//   final message = Message()
//     ..from = Address('fokkakmeni@gmail.com')
//     ..recipients.add('fokkakmeni2@gmail.com')
//     ..subject = 'Test email'
//     // ..text = 'This is a test email sent from a Flutter web app using Firebase\'s SMTP service.'
//     ..html = '<h1>Test email</h1><p>This is a test email sent from a Flutter web app using Firebase\'s SMTP service.</p>';

//   final sendReport =  send(message, smtpServer);

//   print('Message sent: ' + sendReport.toString());
// }




final smtpServer = 'smtp.sendgrid.net';
final smtpPort = 465;
final smtpUsername = 'apikey';
final smtpPassword = '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';

Future<void> sendEmail2() async {
  try {
    final url = Uri.https('api.sendgrid.com', '/v3/mail/send');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $smtpPassword',
  };

  final message = {
    'personalizations': [
      {
        'to': [{'email': 'fokkakmeni2@gmail.com'}],
      },
    ],
    'from': {'email': 'fokkakmeni@gmail.com'},
    'subject': 'test email',
    'content': [
      {'type': 'text/plain', 'value': 'test email'},
    ],
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(message),
  );

  if (response.statusCode != 202) {
    throw Exception('Failed to send email: ${response.statusCode} ${response.body}');
  } 
  } catch (e) {
    print(e); 
  }
  
}

void sendEmail3() async {

  try {
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
  final headers = {
    'Authorization': 'Bearer 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',
    'Content-Type': 'application/json'
  };
  final body = {
    'personalizations': [
      {
        'to': [
          {'email': 'fokkakmeni2@gmail.com'}
        ],
        'subject': 'Test email'
      }
    ],
    'from': {'email': 'fokkakmeni@gmail.com'},
    'content': [
      {'type': 'text/plain', 'value': 'Hello, world!'}
    ]
  };

  final response = await http.post(url, headers: headers, body: json.encode(body));
  if (response.statusCode == 202) {
    print('Email sent successfully');
  } else {
    print('Failed to send email: ${response.body}');
  }
  } catch (e) {
    print(e); 
  }
  
}









    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Form(
          key: formKey,
          child: Row(children: [
            Expanded(child: Container(
              color: kDprimaryColor,
              child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  height: 300,
                                  width: 300,
                                ),
                              ),
                            ),
//                             ElevatedButton(onPressed: ()async{
// final smtpServer = SmtpServer('smtp.sendgrid.net',
//       port: 465,
//       username: 'apikey',
//       password: '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');

//   final message = Message()
//     ..from = Address('fokkakmeni@gmail.com')
//     ..recipients.add('fokkakmeni2@gmail.com')
//     ..subject = 'Test email'
//     // ..text = 'This is a test email sent from a Flutter web app using Firebase\'s SMTP service.'
//     ..html = '<h1>Test email</h1><p>This is a test email sent from a Flutter web app using Firebase\'s SMTP service.</p>';

//   final sendReport = await send(message, smtpServer);

//   print('Message sent: ' + sendReport.toString());

//                             }, child: Text('sss'))
                            
                          ],
                        ),
            )),
            Expanded(child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    right: 0, top: 10, bottom: 20),
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  //"        Login",
                                  'انشاء حساب',
                                  style: GoogleFonts.almarai(
                                      color: kDprimaryColor,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            
                            DefaultTextFild(
                            controller: nameController,
                            label: 'اسم المستخدم',
                            type: TextInputType.text,
                            prefixIcon: Icons.person,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء ادخال اسم المستخدم';
                              }
                              if (value.length < 3 || value.length > 20) {
                                return 'يجب أن يكون اسم المستخدم بين 3 و 20 حرفًا';
                              }
                              // if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                              //   return 'يمكن أن يحتوي اسم المستخدم على أحرف وأرقام فقط';
                              // }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DefaultTextFild(
                            controller: emailController,
                            label: 'البريد الالكترونى',
                            type: TextInputType.emailAddress,
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'الرجاء إدخال عنوان البريد الإلكتروني الخاص بك';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'يرجى إدخال عنوان بريد إلكتروني صالح';
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
                              if (value.length < 8) {
                                return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return 'يجب أن تحتوي كلمة المرور على حرف واحد كبير على الأقل';
                              }
                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'يجب ان تحتوي كلمة المرور على الاقل رقما واحدا';
                              }
                              if (!RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]')
                                  .hasMatch(value)) {
                                return 'يجب أن تحتوي كلمة المرور على حرف خاص واحد على الأقل';
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
                          const SizedBox(height: 20),
                          DefaultTextFild(
                            controller: phoneController,
                            label: 'رقم الهاتف',
                            type: TextInputType.phone,
                            prefixIcon: Icons.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'يرجى إدخال رقم الهاتف الخاص بك';
                              }
                              if (value.length != 11) {
                                return 'رقم الهاتف يجب ان يتكون من 11 رقم';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DefaultTextFild(
                            controller: nationalIDController,
                            label: 'الرقم القومى',
                            type: TextInputType.number,
                            prefixIcon: Icons.credit_card,
                            isNationalID: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'الرجاء إدخال الرقم القومي الخاص بك';
                              }
                              if (value.length != 14) {
                                return 'الرجاء إدخال رقم قومي صالح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DefaultTextFild(
                            controller: addressController,
                            label: 'العنوان',
                            type: TextInputType.text,
                            prefixIcon: Icons.location_on,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'الرجاء إدخال عنوانك';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                dateOfBirthController.text =
                                    DateFormat('MM/dd/yyyy').format(selectedDate);
                              }
                            },
                            child: AbsorbPointer(
                              child: DefaultTextFild(
                                controller: dateOfBirthController,
                                label: 'تاريخ الميلاد',
                                type: TextInputType.datetime,
                                prefixIcon: Icons.calendar_month,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء ادخال تاريخ ميلادك';
                                  }
                                  DateTime dateOfBirth =
                                      DateFormat('MM/dd/yyyy').parseStrict(value);
                                  if (dateOfBirth.isAfter(DateTime.now())) {
                                    return 'من فضلك ادخل تاريخ ميلاد صحيح';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          DefaultButton(
                            text: 'انشاء حساب',
                            // function: sendEmail2('fokkakmeni2@gmail.com','test','test email'),
                            function: sendEmail2,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("لديك عضوبة بالفعل ؟   ",
                                    style: GoogleFonts.almarai()),
                                GestureDetector(
                                  child: Text(
                                    "سجل دخول الان",
                                    style: GoogleFonts.almarai(color: kDprimaryColor),
                                  ),
                                  onTap: () {
                                    // Write Tap Code Here.
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                          ],
                        ),
                      ),
              ],),
            ))
          ]),
        ),
      ),
    );
  }
}