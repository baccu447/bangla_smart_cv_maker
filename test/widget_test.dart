import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bangla_smart_cv_maker/main.dart'; // Ensure this import is correct based on package name
import 'package:bangla_smart_cv_maker/app/modules/home/views/home_view.dart';

void main() {
  testWidgets('HomeView Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomeView(),
      ),
    );

    // Verify that our title is present.
    expect(find.text('Create your first professional CV!'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
