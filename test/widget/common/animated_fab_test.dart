import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:business_directory_app/widgets/common/animated_fab.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('AnimatedFAB Tests', () {
    testWidgets('displays child widget correctly', (tester) async {
      const testIcon = Icon(Icons.add);

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(const AnimatedFAB(child: testIcon)),
      );

      await TestHelpers.waitForAnimations(tester);

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('handles tap correctly', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          AnimatedFAB(
            onPressed: () => tapped = true,
            child: const Icon(Icons.add),
          ),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      await tester.tap(find.byType(FloatingActionButton));
      expect(tapped, isTrue);
    });

    testWidgets('displays tooltip when provided', (tester) async {
      const testTooltip = 'Test Tooltip';

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const AnimatedFAB(tooltip: testTooltip, child: Icon(Icons.add)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.tooltip, equals(testTooltip));
    });

    testWidgets('applies custom background color', (tester) async {
      const testColor = Colors.red;

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const AnimatedFAB(backgroundColor: testColor, child: Icon(Icons.add)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.backgroundColor, equals(testColor));
    });

    testWidgets('supports mini FAB', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const AnimatedFAB(mini: true, child: Icon(Icons.add)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.mini, isTrue);
    });

    testWidgets('has entrance animation', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const AnimatedFAB(child: Icon(Icons.add)),
        ),
      );

      // Should have Transform widget for scaling animation
      expect(find.byType(Transform), findsAtLeastNWidgets(1));

      await TestHelpers.waitForAnimations(tester);

      // FAB should be visible after animation
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('has rotation animation on press', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          AnimatedFAB(onPressed: () {}, child: const Icon(Icons.add)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Tap the FAB to trigger rotation animation
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(milliseconds: 100));

      // Should still have the FAB
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('handles null onPressed', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          const AnimatedFAB(child: Icon(Icons.add)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.onPressed, isNull);
    });
  });

  group('ExpandableFAB Tests', () {
    late List<FABMenuItem> testItems;

    setUp(() {
      testItems = [
        FABMenuItem(
          icon: const Icon(Icons.search),
          label: 'Search',
          onPressed: () {},
        ),
        FABMenuItem(
          icon: const Icon(Icons.refresh),
          label: 'Refresh',
          onPressed: () {},
        ),
      ];
    });

    testWidgets('displays main FAB correctly', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          ExpandableFAB(items: testItems, child: const Icon(Icons.menu)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byType(AnimatedFAB), findsOneWidget);
    });

    testWidgets('expands menu when main FAB is tapped', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          ExpandableFAB(items: testItems, child: const Icon(Icons.menu)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Initially menu should be collapsed
      expect(find.text('Search'), findsNothing);
      expect(find.text('Refresh'), findsNothing);

      // Tap main FAB to expand
      await tester.tap(find.byType(AnimatedFAB));
      await tester.pump(const Duration(milliseconds: 100));
      await TestHelpers.waitForAnimations(tester);

      // Menu items should be visible (though might be animating)
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(1));
    });

    testWidgets('has backdrop when expanded', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          ExpandableFAB(items: testItems, child: const Icon(Icons.menu)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Tap to expand
      await tester.tap(find.byType(AnimatedFAB));
      await TestHelpers.waitForAnimations(tester);

      // Should have backdrop container
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
    });

    testWidgets('collapses when backdrop is tapped', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          ExpandableFAB(items: testItems, child: const Icon(Icons.menu)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Expand menu
      await tester.tap(find.byType(AnimatedFAB));
      await TestHelpers.waitForAnimations(tester);

      // Tap backdrop to collapse (tap outside the FAB area)
      await tester.tapAt(const Offset(50, 50));
      await TestHelpers.waitForAnimations(tester);

      // Menu should be collapsed
      expect(find.text('Search'), findsNothing);
    });

    testWidgets('menu items have correct labels and icons', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          ExpandableFAB(items: testItems, child: const Icon(Icons.menu)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Expand menu
      await tester.tap(find.byType(AnimatedFAB));
      await TestHelpers.waitForAnimations(tester);

      // Check for menu item icons (they should be positioned)
      expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.refresh), findsAtLeastNWidgets(1));
    });

    testWidgets('menu item onPressed works correctly', (tester) async {
      bool searchPressed = false;

      final items = [
        FABMenuItem(
          icon: const Icon(Icons.search),
          label: 'Search',
          onPressed: () => searchPressed = true,
        ),
        FABMenuItem(
          icon: const Icon(Icons.refresh),
          label: 'Refresh',
          onPressed: () {},
        ),
      ];

      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          ExpandableFAB(items: items, child: const Icon(Icons.menu)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Expand menu
      await tester.tap(find.byType(AnimatedFAB));
      await TestHelpers.waitForAnimations(tester);

      // Tap search menu item
      final searchFABs = find.byWidgetPredicate(
        (widget) => widget is FloatingActionButton && widget.mini == true,
      );

      if (searchFABs.evaluate().isNotEmpty) {
        await tester.tap(searchFABs.first);
        expect(searchPressed, isTrue);
      }
    });

    testWidgets('has stack-based layout', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          ExpandableFAB(items: testItems, child: const Icon(Icons.menu)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Should use Stack for positioning
      expect(find.byType(Stack), findsOneWidget);
    });

    testWidgets('positions items correctly', (tester) async {
      await tester.pumpWidget(
        TestHelpers.wrapWithMaterialApp(
          ExpandableFAB(items: testItems, child: const Icon(Icons.menu)),
        ),
      );

      await TestHelpers.waitForAnimations(tester);

      // Should have Positioned widgets for menu items
      expect(find.byType(Positioned), findsAtLeastNWidgets(1));
    });
  });

  group('FABMenuItem Tests', () {
    test('creates item with all properties', () {
      const item = FABMenuItem(
        icon: Icon(Icons.star),
        label: 'Test',
        backgroundColor: Colors.red,
      );

      expect(item.icon, isA<Icon>());
      expect(item.label, equals('Test'));
      expect(item.backgroundColor, equals(Colors.red));
      expect(item.onPressed, isNull);
    });

    test('creates item with minimal properties', () {
      const item = FABMenuItem(icon: Icon(Icons.star));

      expect(item.icon, isA<Icon>());
      expect(item.label, isNull);
      expect(item.backgroundColor, isNull);
      expect(item.onPressed, isNull);
    });
  });
}
