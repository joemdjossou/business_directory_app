import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:business_directory_app/widgets/common/loading_widget.dart';
import 'package:business_directory_app/utils/animation_utils.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('LoadingWidget Tests', () {
    testWidgets('displays loading message when provided', (tester) async {
      const testMessage = 'Loading test data...';

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const LoadingWidget(message: testMessage),
        ),
      );

      // Wait for initial animations
      await TestHelpers.waitForAnimations(tester);

      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('hides message when not provided', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const LoadingWidget(),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Should not find any specific message text
      expect(find.textContaining('Loading'), findsNothing);
    });

    testWidgets('displays skeleton cards when showSkeleton is true', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const LoadingWidget(showSkeleton: true),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Should have multiple containers for skeleton cards
      expect(find.byType(Container), findsAtLeastNWidgets(3));
      
      // Should have ListView for skeleton cards
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('hides skeleton cards when showSkeleton is false', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const LoadingWidget(showSkeleton: false),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Should not have ListView for skeleton cards
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('has circular loading indicator', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const LoadingWidget(),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Should have a container with circular decoration (our custom indicator)
      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(1));
      
      // Should have business icon
      expect(find.byIcon(Icons.business), findsOneWidget);
    });

    testWidgets('displays loading dots', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const LoadingWidget(),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Should have LoadingDots widget
      expect(find.byType(LoadingDots), findsOneWidget);
    });

    testWidgets('has proper layout structure', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const LoadingWidget(
            message: 'Test message',
            showSkeleton: true,
          ),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Should be centered
      expect(find.byType(Center), findsOneWidget);
      
      // Should have Column layout
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    group('Animation Tests', () {
      testWidgets('has rotation animation controller', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const LoadingWidget(),
          ),
        );

        // Check initial state
        expect(find.byType(LoadingWidget), findsOneWidget);
        
        // Wait and check that animations are running
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 500));
        
        // Widget should still be there and animated
        expect(find.byType(LoadingWidget), findsOneWidget);
      });

      testWidgets('has pulse animation', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const LoadingWidget(),
          ),
        );

        // Should have AnimatedBuilder widgets for animations
        expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(2));
        
        await TestHelpers.waitForAnimations(tester);
        
        // Animations should still be running
        expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(2));
      });

      testWidgets('skeleton cards have staggered animations', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const LoadingWidget(showSkeleton: true),
          ),
        );

        // Should have TweenAnimationBuilder for staggered animations
        expect(find.byType(TweenAnimationBuilder), findsAtLeastNWidgets(1));
        
        await TestHelpers.waitForAnimations(tester);
        
        // All skeleton cards should be visible after animations
        expect(find.byType(Container), findsAtLeastNWidgets(3));
      });
    });

    group('Shimmer Effect Tests', () {
      testWidgets('skeleton cards have shimmer effect', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const LoadingWidget(showSkeleton: true),
          ),
        );

        await TestHelpers.waitForAnimations(tester);

        // Should have multiple shimmer containers
        expect(find.byType(Container), findsAtLeastNWidgets(3));
        
        // Should have proper skeleton structure
        expect(find.byType(ListView), findsOneWidget);
      });
    });

    group('State Management Tests', () {
      testWidgets('properly disposes animation controllers', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const LoadingWidget(),
          ),
        );

        await TestHelpers.waitForAnimations(tester);

        // Remove the widget to trigger dispose
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const SizedBox(),
          ),
        );

        // Should not throw any errors
        expect(tester.takeException(), isNull);
      });

      testWidgets('handles rebuild correctly', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const LoadingWidget(message: 'First message'),
          ),
        );

        await TestHelpers.waitForAnimations(tester);
        expect(find.text('First message'), findsOneWidget);

        // Rebuild with different message
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const LoadingWidget(message: 'Second message'),
          ),
        );

        await TestHelpers.waitForAnimations(tester);
        expect(find.text('Second message'), findsOneWidget);
        expect(find.text('First message'), findsNothing);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('has semantic loading information', (tester) async {
        await tester.pumpWidget(
          TestHelpers.wrapWithMaterialApp(
            const LoadingWidget(message: 'Loading businesses...'),
          ),
        );

        await TestHelpers.waitForAnimations(tester);

        // Should have text that screen readers can access
        expect(find.text('Loading businesses...'), findsOneWidget);
      });
    });
  });
}
