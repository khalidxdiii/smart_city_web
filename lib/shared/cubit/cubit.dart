import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/admin/admin_layout_reports_states_screen.dart';
import '../../layout/user/user_layout_reports_states_screen.dart';
import '../../modules/admin/report/visualization/admin_visualization.dart';
import '../../modules/user/user upload report/user_upload_report.dart';
import '../../modules/user/visualization/user_visualization.dart';
import 'states.dart';



class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
   bool clicksearch = true;
   void showsearch(){
    clicksearch = !clicksearch;
    emit(ShowSearch());
   }
    bool x = true;
   void hidesearch(){
    x = !x;
    emit(HideSearch());
   }

  List<Widget> screens = const [
    UserVisualizationScreen(),
    UserUploadReport(),
    UserLayoutReportsStatesScreen(),
  ];

  List<String> titles = [
    'الرئيسية',
    'رفع تقرير',
    'حاله التقرير',
  ];

    List<String> adminTitles = [
    'الرئيسية',
    // 'التقارير المعلقه',
    // 'التقارير قيد المراجعه',
    // 'التقارير المكتمله',
    'التقارير',
  ];

  List<Widget> adminScreens = const [
    AdminVisualizationScreen(),
    AdminLayoutReportsStatesScreen(),
  ];


  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }


}


