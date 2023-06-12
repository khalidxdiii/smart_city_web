import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../shared/component/componant.dart';
import '../../../../shared/component/web/image_card_widget_web.dart';
import '../../../../shared/styles/colors.dart';
import 'cubit web/cubit.dart';
import 'cubit web/states.dart';

class UserUploadReportWeb extends StatelessWidget {
  const UserUploadReportWeb({super.key});

  @override
  Widget build(BuildContext context) {
    var textcontroller = TextEditingController();
    var titlecontroller = TextEditingController();
    var locationcontroller = TextEditingController();

    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (BuildContext context) => CamerawebCubit(),
      child: BlocConsumer<CamerawebCubit, CameraWebStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: context.watch<CamerawebCubit>().isLoading,
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
                            onTap:
                                context.watch<CamerawebCubit>().openSelectImage,
                            onDelete: () {
                              context.read<CamerawebCubit>().clearImage();
                            },
                            isSelectedImage:
                                context.watch<CamerawebCubit>().imageUrl != null,
                            image: context.watch<CamerawebCubit>().imageFile,
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          DefaultTextFild(
                            label: 'عنوان التقرير',
                            controller: titlecontroller,
                            type: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'برجاء ادخال عنوان التقرير';
                              }
                              return null;
                            },
                            prefixIcon: Icons.task,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DefaultTextFild(
                            label: 'المكان',
                            controller: locationcontroller,
                            type: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'برجاء ادخال المكان ';
                              }
                              return null;
                            },
                            prefixIcon: Icons.explore,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          DefaultDropdownFormField(
                            labelText: 'القطاع المختص',
                            initialValue: 'الصحه',
                            options: const ['الصحه', 'التعليم', 'الاستثمار'],
                            onChanged: (value) {
                              context
                                  .read<CamerawebCubit>()
                                  .setDropdownSelectedValue(value!);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DefaultTextFild(
                            label: 'تفاصيل التقرير',
                            controller: textcontroller,
                            type: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'برجاء كتابه وصف التقربر';
                              }
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
                                        .read<CamerawebCubit>()
                                        .isLoadingTrue();
                                    
                                    bool isDone = await context
                                        .read<CamerawebCubit>()
                                        .saveReportToFirestore(
                                            titleDisc:
                                                titlecontroller.text.trim(),
                                            problemDisc:
                                                textcontroller.text.trim(),
                                            locationDisc:
                                                locationcontroller.text.trim(),
                                            dropdownSelectedValue: context
                                                .read<CamerawebCubit>()
                                                .selectedValue!);

                                    if (isDone) {
                                      debugPrint('done upload image');
                                    } else {
                                      debugPrint('error upload image');
                                    }
                                    context.read<CamerawebCubit>().clearImage();
                                    titlecontroller.clear();
                                    textcontroller.clear();
                                    locationcontroller.clear();
                                    //context.read<CameraCubit>().isLoading = false;
                                    context
                                        .read<CamerawebCubit>()
                                        .isLoadingFalse();

                                    var snackBar = SnackBar(
                                      content: Text(
                                        'تم رفع التقرير بنجاح',
                                        style: GoogleFonts.almarai(),
                                      ),
                                      backgroundColor: kDprimaryColor,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                              text: 'حفظ'),
                          //                   IconCardGetImageWidget(
                          //   onPressed: _pickImage,
                          //   image: _pickedImage,
                          // ),
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
    );
  }
}
