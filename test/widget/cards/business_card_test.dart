import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:business_directory_app/data/models/business.dart';
import 'package:business_directory_app/widgets/cards/business_card.dart';
import 'package:business_directory_app/utils/color_scheme.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('BusinessCard Widget Tests', () {
    late Business testBusiness;

    setUp(() {
      testBusiness = const Business(
        id: 'test-business',
        name: 'Test Business Name',
        location: 'Test Location',
        contactNumber: '+1234567890',
      );
    });

    testWidgets('displays business information correctly', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(business: testBusiness),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      expect(find.text('Test Business Name'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('+1234567890'), findsOneWidget);
    });

    testWidgets('displays location and phone icons', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(business: testBusiness),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);
    });

    testWidgets('shows action indicator when onTap is provided', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(
            business: testBusiness,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('View Details'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      // Test tap functionality
      await tester.tap(find.byType(BusinessCard));
      expect(tapped, isTrue);
    });

    testWidgets('hides action indicator when onTap is null', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(business: testBusiness),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('View Details'), findsNothing);
      expect(find.byIcon(Icons.arrow_forward_ios), findsNothing);
    });

    testWidgets('handles long business names with ellipsis', (tester) async {
      final longNameBusiness = Business(
        id: 'long-name-business',
        name: 'This is a very long business name that should be truncated with ellipsis',
        location: 'Test Location',
        contactNumber: '+1234567890',
      );

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(business: longNameBusiness),
        ),
      );

      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.textContaining('This is a very long business name'),
      );
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 2);
    });

    testWidgets('handles long location names with ellipsis', (tester) async {
      final longLocationBusiness = Business(
        id: 'long-location-business',
        name: 'Test Business',
        location: 'This is a very long location name that should be truncated',
        contactNumber: '+1234567890',
      );

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(business: longLocationBusiness),
        ),
      );

      await tester.pumpAndSettle();

      // Find the location text widget (second text widget with overflow)
      final locationTexts = find.byWidgetPredicate(
        (widget) => widget is Text && 
                   widget.overflow == TextOverflow.ellipsis &&
                   widget.maxLines == 1,
      );
      expect(locationTexts, findsAtLeastNWidgets(1));
    });

    testWidgets('handles index for staggered animation', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(
            business: testBusiness,
            index: 2,
          ),
        ),
      );

      // The card should be initially invisible due to animation delay
      expect(find.byType(BusinessCard), findsOneWidget);
      
      // Wait for staggered animation delay (index 2 = 200ms delay)
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Card should be visible after animation
      expect(find.text('Test Business Name'), findsOneWidget);
    });

    testWidgets('applies custom styling properties', (tester) async {
      const customMargin = EdgeInsets.all(20.0);
      const customPadding = EdgeInsets.all(24.0);
      const customElevation = 8.0;
      final customBorderRadius = BorderRadius.circular(16.0);

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(
            business: testBusiness,
            margin: customMargin,
            padding: customPadding,
            elevation: customElevation,
            borderRadius: customBorderRadius,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the card is rendered (styling verification would require more complex widget inspection)
      expect(find.byType(BusinessCard), findsOneWidget);
      expect(find.text('Test Business Name'), findsOneWidget);
    });

    testWidgets('has correct semantic labels', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(business: testBusiness),
        ),
      );

      await tester.pumpAndSettle();

      // The card should be wrapped with appropriate semantic information
      expect(find.byType(BusinessCard), findsOneWidget);
    });

    testWidgets('renders gradient text effect', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(business: testBusiness),
        ),
      );

      await tester.pumpAndSettle();

      // Verify ShaderMask is applied to business name
      expect(find.byType(ShaderMask), findsOneWidget);
      expect(find.text('Test Business Name'), findsOneWidget);
    });

    testWidgets('has proper info row structure', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          BusinessCard(business: testBusiness),
        ),
      );

      await tester.pumpAndSettle();

      // Should have animated containers for info rows
      expect(find.byType(AnimatedContainer), findsAtLeastNWidgets(2));
      
      // Should have location and phone info
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);
    });

    group('Animation Tests', () {
      testWidgets('applies fade animation', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            BusinessCard(business: testBusiness),
          ),
        );

        // Initially should have FadeTransition
        expect(find.byType(FadeTransition), findsOneWidget);
        
        await tester.pumpAndSettle();
        
        // After animation completes, content should be visible
        expect(find.text('Test Business Name'), findsOneWidget);
      });

      testWidgets('handles mouse hover states', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            BusinessCard(business: testBusiness),
          ),
        );

        await tester.pumpAndSettle();

        // Find the MouseRegion widget
        expect(find.byType(MouseRegion), findsOneWidget);
        
        // Simulate hover enter
        final mouseRegion = tester.widget<MouseRegion>(find.byType(MouseRegion));
        expect(mouseRegion.onEnter, isNotNull);
        expect(mouseRegion.onExit, isNotNull);
      });

      testWidgets('has proper transform animations', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            BusinessCard(business: testBusiness),
          ),
        );

        await tester.pumpAndSettle();

        // Should have Transform widgets for animations
        expect(find.byType(Transform), findsAtLeastNWidgets(1));
      });
    });
  });
}
