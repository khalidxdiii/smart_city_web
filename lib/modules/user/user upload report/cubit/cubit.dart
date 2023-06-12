import 'dart:async';
// import 'dart:html';
import 'dart:io';
// import 'dart:html' as html;
// import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


import 'states.dart';



class CameraCubit extends Cubit<CameraStates> {
  CameraCubit() : super(CameraInitialState());

  static CameraCubit get(context) => BlocProvider.of(context);
  bool isLoading = false;
  
  File? image;
  String? selectedValue='الصحه'; 
  void clearImage() {
    image = null;
    emit(ClearImageState());
  }

  void isLoadingTrue() {
    isLoading = true;
    emit(LoadingTrue());
  }

  void isLoadingFalse() {
    isLoading = false;
    emit(LoadingFalse());
  }
  void setDropdownSelectedValue(String value ) { // <-- new method to update selected value
    selectedValue = value;
    emit(CameraSetSelectedValueState());
  }

  Future<void> getimage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(CameraImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(CameraImagePickedErrorState());
    }
  }

  




// Future<void> getimageWeb() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

//   if (result != null) {
//     PlatformFile file = result.files.first;
//     final reader = FileReader();
//     reader.readAsArrayBuffer(file.readStream!);
//     reader.onLoadEnd.listen((event) async {
//       final bytes = reader.result as List<int>;
//       final fileName = path.basename(file.name);

//       // Do whatever you need to do with the picked image bytes
//     });
//   } else {
//     debugPrint('No image selected.');
//   }
// }

//   Future<html.File> pickImageWeb() async {
//   final completer = Completer<html.File>();
//   final input = html.FileUploadInputElement();
//   input.accept = 'image/*';
//   input.click();
//   input.onChange.listen((event) {
//     final file = input.files!.first;
//     completer.complete(file);
//   });
//   return completer.future;
// }

}



