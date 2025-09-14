import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:business_directory_app/utils/color_scheme.dart';

void main() {
  group('AppColorScheme Tests', () {
    group('Color Constants', () {
      test('primary colors are defined correctly', () {
        expect(AppColorScheme.primaryGreen, const Color(0xFF4CAF50));
        expect(AppColorScheme.primaryGreenLight, const Color(0xFF81C784));
        expect(AppColorScheme.primaryGreenDark, const Color(0xFF388E3C));
        expect(AppColorScheme.accentGreen, const Color(0xFF8BC34A));
      });

      test('gradient colors are defined correctly', () {
        expect(AppColorScheme.gradientStart, const Color(0xFF66BB6A));
        expect(AppColorScheme.gradientMiddle, const Color(0xFF4CAF50));
        expect(AppColorScheme.gradientEnd, const Color(0xFF2E7D32));
      });

      test('text colors are defined correctly', () {
        expect(AppColorScheme.textPrimary, const Color(0xFF212121));
        expect(AppColorScheme.textSecondary, const Color(0xFF757575));
        expect(AppColorScheme.textHint, const Color(0xFFBDBDBD));
        expect(AppColorScheme.textOnPrimary, const Color(0xFFFFFFFF));
      });
    });

    group('ColorScheme Generation', () {
      test('lightColorScheme has correct brightness', () {
        final colorScheme = AppColorScheme.lightColorScheme;
        expect(colorScheme.brightness, Brightness.light);
        expect(colorScheme.primary, AppColorScheme.primaryGreen);
        expect(colorScheme.onPrimary, AppColorScheme.textOnPrimary);
      });

      test('darkColorScheme has correct brightness', () {
        final colorScheme = AppColorScheme.darkColorScheme;
        expect(colorScheme.brightness, Brightness.dark);
        expect(colorScheme.primary, AppColorScheme.primaryGreenLight);
      });

      test('both color schemes have all required colors', () {
        final lightScheme = AppColorScheme.lightColorScheme;
        final darkScheme = AppColorScheme.darkColorScheme;

        // Test that all colors are non-null and valid
        expect(lightScheme.primary, isA<Color>());
        expect(lightScheme.secondary, isA<Color>());
        expect(lightScheme.surface, isA<Color>());
        expect(lightScheme.error, isA<Color>());

        expect(darkScheme.primary, isA<Color>());
        expect(darkScheme.secondary, isA<Color>());
        expect(darkScheme.surface, isA<Color>());
        expect(darkScheme.error, isA<Color>());
      });
    });

    group('Business Categories', () {
      test('getCategoryColor returns correct colors for known categories', () {
        expect(AppColorScheme.getCategoryColor('restaurant'), const Color(0xFFFF5722));
        expect(AppColorScheme.getCategoryColor('shopping'), const Color(0xFF9C27B0));
        expect(AppColorScheme.getCategoryColor('services'), AppColorScheme.primaryGreen);
        expect(AppColorScheme.getCategoryColor('healthcare'), const Color(0xFF2196F3));
        expect(AppColorScheme.getCategoryColor('automotive'), const Color(0xFF607D8B));
        expect(AppColorScheme.getCategoryColor('beauty'), const Color(0xFFE91E63));
        expect(AppColorScheme.getCategoryColor('education'), const Color(0xFF3F51B5));
        expect(AppColorScheme.getCategoryColor('entertainment'), const Color(0xFFFF9800));
        expect(AppColorScheme.getCategoryColor('finance'), const Color(0xFF4CAF50));
        expect(AppColorScheme.getCategoryColor('technology'), const Color(0xFF795548));
      });

      test('getCategoryColor is case insensitive', () {
        expect(AppColorScheme.getCategoryColor('RESTAURANT'), const Color(0xFFFF5722));
        expect(AppColorScheme.getCategoryColor('Restaurant'), const Color(0xFFFF5722));
        expect(AppColorScheme.getCategoryColor('rEsTaUrAnT'), const Color(0xFFFF5722));
      });

      test('getCategoryColor returns default for unknown categories', () {
        expect(AppColorScheme.getCategoryColor('unknown'), AppColorScheme.primaryGreen);
        expect(AppColorScheme.getCategoryColor(''), AppColorScheme.primaryGreen);
        expect(AppColorScheme.getCategoryColor('not-a-category'), AppColorScheme.primaryGreen);
      });
    });

    group('Status Colors', () {
      test('getStatusColor returns correct colors for known statuses', () {
        expect(AppColorScheme.getStatusColor('active'), AppColorScheme.online);
        expect(AppColorScheme.getStatusColor('open'), AppColorScheme.online);
        expect(AppColorScheme.getStatusColor('online'), AppColorScheme.online);
        
        expect(AppColorScheme.getStatusColor('inactive'), AppColorScheme.offline);
        expect(AppColorScheme.getStatusColor('closed'), AppColorScheme.offline);
        expect(AppColorScheme.getStatusColor('offline'), AppColorScheme.offline);
        
        expect(AppColorScheme.getStatusColor('pending'), AppColorScheme.pending);
        expect(AppColorScheme.getStatusColor('processing'), AppColorScheme.pending);
      });

      test('getStatusColor is case insensitive', () {
        expect(AppColorScheme.getStatusColor('ACTIVE'), AppColorScheme.online);
        expect(AppColorScheme.getStatusColor('Active'), AppColorScheme.online);
        expect(AppColorScheme.getStatusColor('AcTiVe'), AppColorScheme.online);
      });

      test('getStatusColor returns default for unknown statuses', () {
        expect(AppColorScheme.getStatusColor('unknown'), AppColorScheme.textSecondary);
        expect(AppColorScheme.getStatusColor(''), AppColorScheme.textSecondary);
        expect(AppColorScheme.getStatusColor('not-a-status'), AppColorScheme.textSecondary);
      });
    });

    group('Gradient Definitions', () {
      test('primaryGradient has correct properties', () {
        const gradient = AppColorScheme.primaryGradient;
        
        expect(gradient.begin, Alignment.topLeft);
        expect(gradient.end, Alignment.bottomRight);
        expect(gradient.colors.length, 3);
        expect(gradient.colors[0], AppColorScheme.gradientStart);
        expect(gradient.colors[1], AppColorScheme.gradientMiddle);
        expect(gradient.colors[2], AppColorScheme.gradientEnd);
        expect(gradient.stops, [0.0, 0.5, 1.0]);
      });

      test('lightGradient has correct properties', () {
        const gradient = AppColorScheme.lightGradient;
        
        expect(gradient.begin, Alignment.topCenter);
        expect(gradient.end, Alignment.bottomCenter);
        expect(gradient.colors.length, 2);
        expect(gradient.colors[0], AppColorScheme.primaryGreenLight);
        expect(gradient.colors[1], AppColorScheme.primaryGreen);
        expect(gradient.stops, [0.0, 1.0]);
      });

      test('circularGradient has correct properties', () {
        const gradient = AppColorScheme.circularGradient;
        
        expect(gradient.center, Alignment.center);
        expect(gradient.radius, 0.8);
        expect(gradient.colors.length, 3);
        expect(gradient.colors[0], AppColorScheme.gradientStart);
        expect(gradient.colors[1], AppColorScheme.gradientMiddle);
        expect(gradient.colors[2], AppColorScheme.gradientEnd);
        expect(gradient.stops, [0.0, 0.6, 1.0]);
      });
    });

    group('Color Utility Methods', () {
      test('withOpacity creates color with correct opacity', () {
        const testColor = Color(0xFF123456);
        final result = AppColorScheme.withOpacity(testColor, 0.5);
        
        expect(result.alpha, equals((255 * 0.5).round()));
        expect(result.red, equals(testColor.red));
        expect(result.green, equals(testColor.green));
        expect(result.blue, equals(testColor.blue));
      });

      test('lighten makes color lighter', () {
        const testColor = Color(0xFF808080); // Medium gray
        final result = AppColorScheme.lighten(testColor, 0.2);
        
        final originalHsl = HSLColor.fromColor(testColor);
        final resultHsl = HSLColor.fromColor(result);
        
        expect(resultHsl.lightness, greaterThan(originalHsl.lightness));
      });

      test('darken makes color darker', () {
        const testColor = Color(0xFF808080); // Medium gray
        final result = AppColorScheme.darken(testColor, 0.2);
        
        final originalHsl = HSLColor.fromColor(testColor);
        final resultHsl = HSLColor.fromColor(result);
        
        expect(resultHsl.lightness, lessThan(originalHsl.lightness));
      });

      test('lighten and darken clamp values', () {
        // Test with white (should stay white when lightened)
        const white = Color(0xFFFFFFFF);
        final lightenedWhite = AppColorScheme.lighten(white, 0.5);
        expect(lightenedWhite, equals(white));

        // Test with black (should stay black when darkened)
        const black = Color(0xFF000000);
        final darkenedBlack = AppColorScheme.darken(black, 0.5);
        expect(darkenedBlack, equals(black));
      });
    });
  });

  group('AppColorSchemeExtension Tests', () {
    test('categoryColor extension method works', () {
      const colorScheme = ColorScheme.light();
      
      expect(colorScheme.categoryColor('restaurant'), const Color(0xFFFF5722));
      expect(colorScheme.categoryColor('unknown'), AppColorScheme.primaryGreen);
    });

    test('statusColor extension method works', () {
      const colorScheme = ColorScheme.light();
      
      expect(colorScheme.statusColor('active'), AppColorScheme.online);
      expect(colorScheme.statusColor('unknown'), AppColorScheme.textSecondary);
    });

    test('businessCardSurface returns correct color for brightness', () {
      const lightScheme = ColorScheme.light();
      const darkScheme = ColorScheme.dark();
      
      expect(lightScheme.businessCardSurface, AppColorScheme.cardBackground);
      expect(darkScheme.businessCardSurface, AppColorScheme.cardBackgroundDark);
    });

    test('interactiveSurface returns correct color for brightness', () {
      const lightScheme = ColorScheme.light();
      const darkScheme = ColorScheme.dark();
      
      expect(lightScheme.interactiveSurface, AppColorScheme.ripple);
      expect(darkScheme.interactiveSurface, AppColorScheme.splash);
    });
  });
}
