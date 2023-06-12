import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../layout/admin/admin_layout_screen.dart';
import '../../../models/problem_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/component/componant.dart';
import '../../../shared/component/web/image_card_widget_web.dart';
import '../../../shared/styles/colors.dart';
import 'web/cubit web/cubit.dart';
import 'web/cubit web/states.dart';

class AdminUploadImageMobile extends StatelessWidget {
  const AdminUploadImageMobile(
      {super.key, this.problem, this.user, this.reportID});
  final MAProblemModel? problem;
  final MAUserModel? user;
  final String? reportID;

  @override
  Widget build(BuildContext context) {
    var adminNotesToUser = TextEditingController();

    var formKey = GlobalKey<FormState>();
    //bool isLoading = true;

    return Scaffold(
     
      body: BlocProvider(
        create: (BuildContext context) => AdminUploadReportwebCubit(),
        child: BlocConsumer<AdminUploadReportwebCubit, AdminUploadReportwebStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: context.watch<AdminUploadReportwebCubit>().isLoading,
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      //color: kDprimaryColor[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            IconCardGetImageWidgetWeb(
                              onTap: context
                                  .watch<AdminUploadReportwebCubit>()
                                  .openSelectImage,
                              onDelete: () {
                                context
                                    .read<AdminUploadReportwebCubit>()
                                    .clearImage();
                              },
                              isSelectedImage: context
                                      .watch<AdminUploadReportwebCubit>()
                                      .imageUrl !=
                                  null,
                              image: context
                                  .watch<AdminUploadReportwebCubit>()
                                  .imageFile,
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            DefaultTextFild(
                              label: 'ملاحظات المسؤل',
                              controller: adminNotesToUser,
                              type: TextInputType.text,
                              validator: (value) {
                                return null;
                              },
                              prefixIcon: Icons.edit,
                              minLines: 7,
                              maxLines: 7,
                            ),

                            //
                            const SizedBox(
                              height: 20,
                            ),
                            DefaultButton(
                                function: () async {
                                  try {
                                    if (formKey.currentState!.validate()) {
                                      context
                                          .read<AdminUploadReportwebCubit>()
                                          .isLoadingTrue();
                                     
                                      bool isDone = await context
                                          .read<AdminUploadReportwebCubit>()
                                          .adminFinshReport(
                                            reportID: problem!.reportID!,
                                            // imageAfterUrl: imageAfterUrl,
                                            adminNotesToUser:
                                                adminNotesToUser.text.trim(),
                                          );

                                      if (isDone) {
                                        debugPrint('done upload image');
                                      } else {
                                        debugPrint('finish upload image');
                                      }
                                      context
                                          .read<AdminUploadReportwebCubit>()
                                          .clearImage();
                                      adminNotesToUser.clear();

                                      //context.read<CameraCubit>().isLoading = false;
                                      context
                                          .read<AdminUploadReportwebCubit>()
                                          .isLoadingFalse();

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminLayoutScreen(),
                                        ),
                                      );

                                      var snackBar = SnackBar(
                                        content: Text(
                                          'تم الرفع بنجاح',
                                          style: GoogleFonts.almarai(),
                                        ),
                                        backgroundColor: kDprimaryColor,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  } catch (e) {
                                    debugPrint(e.toString());
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        e.toString(),
                                        style: GoogleFonts.almarai(),
                                      ),
                                      backgroundColor: kDprimaryColor,
                                    ));
                                  }
                                },
                                text: 'انهاء التقرير')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
