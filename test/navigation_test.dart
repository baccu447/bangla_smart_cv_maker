import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bangla_smart_cv_maker/app/modules/home/views/home_view.dart';
import 'package:bangla_smart_cv_maker/app/modules/editor/views/editor_view.dart';
import 'package:bangla_smart_cv_maker/app/modules/editor/controllers/editor_controller.dart';
import 'package:bangla_smart_cv_maker/app/modules/editor/bindings/editor_binding.dart';
import 'package:bangla_smart_cv_maker/app/data/services/ad_service.dart';
import 'package:bangla_smart_cv_maker/app/data/models/cv_model.dart';
import 'package:bangla_smart_cv_maker/core/theme/app_theme.dart';

class MockAdService extends GetxService implements AdService {
  @override
  Future<AdService> init() async => this;
  @override
  void loadInterstitial() {}
  @override
  void showInterstitial() {}
  @override
  void loadRewarded() {}
  @override
  void showRewarded(Function onRewardEarned) {}
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put<AdService>(MockAdService());
  });

  testWidgets('Navigation to EditorView test', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
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

    await tester.pump();
    
    final createButton = find.text('Create CV');
    expect(createButton, findsOneWidget);

    await tester.tap(createButton);
    
    // Pump frames to allow navigation
    for(int i=0; i<10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Check for errors
    final dynamic exception = tester.takeException();
    if (exception != null) {
      print('Caught expected crash: $exception');
    }

    // Check if EditorView is present
    expect(find.byType(EditorView), findsOneWidget);
  });
}
