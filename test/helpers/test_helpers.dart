import 'package:business_directory_app/data/models/business.dart';
import 'package:business_directory_app/utils/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelpers {
  /// Wraps a widget with MaterialApp for testing
  static Widget wrapWithMaterialApp(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: AppColorScheme.lightColorScheme,
        useMaterial3: true,
      ),
      home: Scaffold(body: child),
    );
  }

  /// Wraps a widget with MaterialApp and custom theme
  static Widget wrapWithCustomTheme(Widget child, {ThemeData? theme}) {
    return MaterialApp(
      theme:
          theme ??
          ThemeData(
            colorScheme: AppColorScheme.lightColorScheme,
            useMaterial3: true,
          ),
      home: Scaffold(body: child),
    );
  }

  /// Creates a test business object
  static Business createTestBusiness({
    String id = 'test-business',
    String name = 'Test Business',
    String location = 'Test Location',
    String contactNumber = '+1234567890',
  }) {
    return Business(
      id: id,
      name: name,
      location: location,
      contactNumber: contactNumber,
    );
  }

  /// Creates a list of test businesses
  static List<Business> createTestBusinessList(int count) {
    return List.generate(
      count,
      (index) => createTestBusiness(
        id: 'test-business-$index',
        name: 'Test Business $index',
        location: 'Location $index',
        contactNumber: '+123456789$index',
      ),
    );
  }

  /// Creates test business JSON
  static Map<String, dynamic> createTestBusinessJson({
    String? bizName,
    String? location,
    String? contactNumber,
  }) {
    return {
      'biz_name': bizName ?? 'Test Business',
      'bss_location': location ?? 'Test Location',
      'contct_no': contactNumber ?? '+1234567890',
    };
  }

  /// Pumps and settles with a reasonable timeout
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
  }

  /// Waits for animations to complete
  static Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }
}
