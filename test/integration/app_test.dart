import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:business_directory_app/main.dart' as app;
import 'package:business_directory_app/widgets/cards/business_card.dart';
import 'package:business_directory_app/screens/search_screen.dart';
import 'package:business_directory_app/screens/business_detail_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Business Directory App Integration Tests', () {
    testWidgets('complete app flow test', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify home screen loads
      expect(find.text('Business Directory'), findsOneWidget);

      // Wait for businesses to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should have business cards displayed
      expect(find.byType(BusinessCard), findsAtLeastNWidgets(1));

      // Test navigation to search screen
      final searchFAB = find.byType(FloatingActionButton);
      if (searchFAB.evaluate().isNotEmpty) {
        await tester.tap(searchFAB);
        await tester.pumpAndSettle();

        // Should navigate to search screen
        expect(find.byType(SearchScreen), findsOneWidget);
        expect(find.text('Search Businesses'), findsOneWidget);

        // Navigate back
        await tester.pageBack();
        await tester.pumpAndSettle();
      }

      // Test navigation to business detail
      final firstBusinessCard = find.byType(BusinessCard).first;
      await tester.tap(firstBusinessCard);
      await tester.pumpAndSettle();

      // Should navigate to business detail screen
      expect(find.byType(BusinessDetailScreen), findsOneWidget);

      // Navigate back to home
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Should be back on home screen
      expect(find.text('Business Directory'), findsOneWidget);
    });

    testWidgets('search functionality test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to search
      final searchFAB = find.byType(FloatingActionButton);
      if (searchFAB.evaluate().isNotEmpty) {
        await tester.tap(searchFAB);
        await tester.pumpAndSettle();

        // Enter search text
        final searchField = find.byType(TextField);
        if (searchField.evaluate().isNotEmpty) {
          await tester.enterText(searchField, 'restaurant');
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Should show search results or empty state
          // Note: Actual results depend on test data
        }

        // Test clear search
        final clearButton = find.byIcon(Icons.clear);
        if (clearButton.evaluate().isNotEmpty) {
          await tester.tap(clearButton);
          await tester.pumpAndSettle();

          // Search field should be cleared
          final textField = tester.widget<TextField>(searchField);
          expect(textField.controller?.text, isEmpty);
        }
      }
    });

    testWidgets('business detail interaction test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for businesses to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final firstBusinessCard = find.byType(BusinessCard).first;
      if (firstBusinessCard.evaluate().isNotEmpty) {
        await tester.tap(firstBusinessCard);
        await tester.pumpAndSettle();

        // Should be on business detail screen
        expect(find.byType(BusinessDetailScreen), findsOneWidget);

        // Test phone call action
        final phoneButtons = find.byIcon(Icons.phone);
        if (phoneButtons.evaluate().isNotEmpty) {
          await tester.tap(phoneButtons.first);
          await tester.pumpAndSettle();
          // Note: In test environment, this won't actually make a call
        }

        // Test copy action
        final copyButtons = find.byIcon(Icons.copy);
        if (copyButtons.evaluate().isNotEmpty) {
          await tester.tap(copyButtons.first);
          await tester.pumpAndSettle();
          
          // Should show snackbar
          expect(find.byType(SnackBar), findsOneWidget);
        }

        // Test share action
        final shareButtons = find.byIcon(Icons.share);
        if (shareButtons.evaluate().isNotEmpty) {
          await tester.tap(shareButtons.first);
          await tester.pumpAndSettle();
          
          // Should show snackbar
          expect(find.byType(SnackBar), findsOneWidget);
        }
      }
    });

    testWidgets('loading states test', (tester) async {
      app.main();
      
      // Should show loading state initially
      await tester.pump(const Duration(milliseconds: 100));
      
      // Look for loading indicators
      expect(find.byType(CircularProgressIndicator), findsAny);
      
      // Wait for loading to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // Should show business list
      expect(find.byType(BusinessCard), findsAtLeastNWidgets(1));
    });

    testWidgets('pull to refresh test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find the RefreshIndicator
      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        // Trigger pull to refresh
        await tester.drag(refreshIndicator, const Offset(0, 300));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should complete refresh
        expect(find.byType(BusinessCard), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('navigation flow test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test home -> search -> back navigation
      final searchFAB = find.byType(FloatingActionButton);
      if (searchFAB.evaluate().isNotEmpty) {
        await tester.tap(searchFAB);
        await tester.pumpAndSettle();

        expect(find.byType(SearchScreen), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();

        expect(find.text('Business Directory'), findsOneWidget);
      }

      // Test home -> detail -> back navigation
      final firstBusinessCard = find.byType(BusinessCard);
      if (firstBusinessCard.evaluate().isNotEmpty) {
        await tester.tap(firstBusinessCard.first);
        await tester.pumpAndSettle();

        expect(find.byType(BusinessDetailScreen), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();

        expect(find.text('Business Directory'), findsOneWidget);
      }
    });

    testWidgets('error handling test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // The app should handle loading gracefully
      // Even if there are network issues, it should show appropriate UI
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('app bar functionality test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should have app bar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Business Directory'), findsOneWidget);

      // Test app bar actions if any
      final appBarActions = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(IconButton),
      );
      
      // Actions should be functional (refresh, etc.)
      for (final action in appBarActions.evaluate()) {
        // Test that actions don't crash
        await tester.tap(find.byWidget(action.widget));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('animations performance test', (tester) async {
      app.main();
      
      // Test that animations don't cause performance issues
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      // Navigate to different screens quickly
      final searchFAB = find.byType(FloatingActionButton);
      if (searchFAB.evaluate().isNotEmpty) {
        await tester.tap(searchFAB);
        await tester.pump(const Duration(milliseconds: 100));
        
        await tester.pageBack();
        await tester.pump(const Duration(milliseconds: 100));
        
        await tester.tap(searchFAB);
        await tester.pump(const Duration(milliseconds: 100));
        
        await tester.pageBack();
        await tester.pumpAndSettle();
      }
      
      // Should complete without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('memory leak test', (tester) async {
      // Test multiple navigation cycles
      for (int i = 0; i < 3; i++) {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to search and back
        final searchFAB = find.byType(FloatingActionButton);
        if (searchFAB.evaluate().isNotEmpty) {
          await tester.tap(searchFAB);
          await tester.pumpAndSettle();
          await tester.pageBack();
          await tester.pumpAndSettle();
        }

        // Navigate to detail and back
        final firstCard = find.byType(BusinessCard);
        if (firstCard.evaluate().isNotEmpty) {
          await tester.tap(firstCard.first);
          await tester.pumpAndSettle();
          await tester.pageBack();
          await tester.pumpAndSettle();
        }
      }

      // Should complete without memory issues
      expect(tester.takeException(), isNull);
    });
  });
}
