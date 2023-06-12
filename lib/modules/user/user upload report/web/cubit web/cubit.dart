import 'dart:async';
// import 'dart:html';
import 'dart:io';
import 'dart:html' as html;
// import 'dart:html';
//  import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'states.dart';
import 'package:geolocator/geolocator.dart';





class CamerawebCubit extends Cubit<CameraWebStates> {
  CamerawebCubit() : super(CameraInitialState());

  static CamerawebCubit get(context) => BlocProvider.of(context);
  bool isLoading = false;
  
  File? image;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  String? selectedValue='الصحه'; 
  void clearImage() {
    imageUrl = null;
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


File? pickedmobileImage;
Uint8List webImage = Uint8List(8);
Future <void> pickWebImage() async {
  if(!kIsWeb){
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      var selected =File(image.path);
      // setState((){
        pickedmobileImage =selected;
      // });
    } else {
      print('na image has been picked');
    }
  }else if(kIsWeb){
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      var f = await image.readAsBytes();
      // setState((){
       webImage =f;
       pickedmobileImage = File('a');
      // });
    } else {
      print('na image has been picked');
    }
  }else{
    print('Someting wont wrong');
  }
}
XFile? imagetest;
Future<void> pickWebImage2() async {
  final ImagePicker _picker = ImagePicker();
  final imagetest = await _picker.pickImage(source: ImageSource.gallery);
  
  if (imagetest != null) {
    final bytes = await imagetest.readAsBytes();
    // setState(() {
      webImage = bytes;
    // });
    print('image slected');
  } else {
    print('No image has been selected.');
  }
}


html.File? imageFile;
  String? imageUrl;

  void openSelectImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file);

      reader.onLoadEnd.listen((event) {
       
          imageFile = file;
          imageUrl = reader.result as String?;
        emit(CameraImagePickedSuccessState());
      });
    });
  }



Future<bool> saveReportToFirestore({
  String? url,
  required String titleDisc,
  required String problemDisc,
  required String locationDisc,
  required String dropdownSelectedValue,
}) async {
try {
    if (imageFile != null) {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(imageFile!);
    reader.onLoadEnd.listen((event) async {
      final bytes = reader.result as List<int>;
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final storageRef = FirebaseStorage.instance.ref().child('images/${imageFile!.name}');
      final uploadResult = await storageRef.putData(Uint8List.fromList(bytes), metadata);
      final imageUrl = await storageRef.getDownloadURL();

      // Get the current location
      final currentPosition = await Geolocator.getCurrentPosition();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('problems').get();
      int size = querySnapshot.size;

      final report = {
        'image_url': imageUrl,
        // 'createdAt': Timestamp.now(),
        'title_disc': titleDisc,
        'problem_disc': problemDisc,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': Timestamp.now(),
        'locationDisc': locationDisc,
        'report_id': '${size + 1}',
        'report_state': 'معلق',
        'latitude': currentPosition.latitude,
        'longitude': currentPosition.longitude,
        'selectedValue': dropdownSelectedValue,
      };

      await FirebaseFirestore.instance.collection('problems').doc('${size + 1}').set(report);
      debugPrint('finish upload problem');
      imageFile = null;
      emit(UploadReportToFirebaseSucssesState());
      
    });
  return true;} 
} catch (e) {
  print(e); 
  emit(UploadReportToFirebaseErrorState());
}
  return false;
}
}



