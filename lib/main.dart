import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/data/models/cv_model.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/modules/editor/views/editor_view.dart';
import 'app/modules/editor/bindings/editor_binding.dart';
import 'app/data/services/ad_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(CVModelAdapter());
  Hive.registerAdapter(EducationAdapter());
  Hive.registerAdapter(ExperienceAdapter());
  
  // Open the box
  await Hive.openBox<CVModel>('cvs');

  await Get.putAsync(() => AdService().init());
  
  runApp(
    GetMaterialApp(
      title: "Bangla Smart CV Maker",
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeView()),
        GetPage(
          name: '/editor', 
          page: () => const EditorView(),
          binding: EditorBinding(),
        ),
      ],
    ),
  );
}
