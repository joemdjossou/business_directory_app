import 'package:flutter/material.dart';

/// Color scheme inspired by Geny app design
/// Features a beautiful green gradient and modern aesthetic
class AppColorScheme {
  // Private constructor to prevent instantiation
  AppColorScheme._();

  // Primary Colors - Green gradient from the Geny app
  static const Color primaryGreen = Color(0xFF4CAF50); // Main green
  static const Color primaryGreenLight = Color(0xFF81C784); // Light green
  static const Color primaryGreenDark = Color(0xFF388E3C); // Dark green
  static const Color accentGreen = Color(0xFF8BC34A); // Accent green

  // Gradient Colors - Matching the circular gradient in the image
  static const Color gradientStart = Color(0xFF66BB6A); // Light green start
  static const Color gradientMiddle = Color(0xFF4CAF50); // Middle green
  static const Color gradientEnd = Color(0xFF2E7D32); // Deep green end

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA); // Very light gray
  static const Color backgroundDark = Color(0xFF121212); // Dark mode background
  static const Color surfaceLight = Color(0xFFFFFFFF); // White surface
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark surface

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Primary text
  static const Color textSecondary = Color(0xFF757575); // Secondary text
  static const Color textHint = Color(0xFFBDBDBD); // Hint text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text on primary

  // Accent Colors
  static const Color accent = Color(0xFF03DAC6); // Teal accent
  static const Color error = Color(0xFFB00020); // Error red
  static const Color warning = Color(0xFFFF9800); // Warning orange
  static const Color success = Color(0xFF4CAF50); // Success green
  static const Color info = Color(0xFF2196F3); // Info blue

  // Card and Surface Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF2C2C2C);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Interactive Colors
  static const Color ripple = Color(0x1F4CAF50); // Green ripple
  static const Color splash = Color(0x1F4CAF50); // Green splash
  static const Color highlight = Color(0x1F4CAF50); // Green highlight

  // Status Colors
  static const Color online = Color(0xFF4CAF50); // Online status
  static const Color offline = Color(0xFF9E9E9E); // Offline status
  static const Color pending = Color(0xFFFF9800); // Pending status

  /// Light Theme Color Scheme
  static ColorScheme get lightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: primaryGreen,
    onPrimary: textOnPrimary,
    primaryContainer: primaryGreenLight,
    onPrimaryContainer: textPrimary,
    secondary: accentGreen,
    onSecondary: textOnPrimary,
    secondaryContainer: Color(0xFFE8F5E8),
    onSecondaryContainer: textPrimary,
    tertiary: accent,
    onTertiary: textOnPrimary,
    tertiaryContainer: Color(0xFFE0F2F1),
    onTertiaryContainer: textPrimary,
    error: error,
    onError: textOnPrimary,
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFB71C1C),
    surface: surfaceLight,
    onSurface: textPrimary,
    onSurfaceVariant: textSecondary,
    outline: divider,
    outlineVariant: Color(0xFFE0E0E0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: surfaceDark,
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: primaryGreenLight,
    surfaceTint: primaryGreen,
  );

  /// Dark Theme Color Scheme
  static ColorScheme get darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: primaryGreenLight,
    onPrimary: Color(0xFF003300),
    primaryContainer: primaryGreenDark,
    onPrimaryContainer: Color(0xFFC8E6C9),
    secondary: accentGreen,
    onSecondary: Color(0xFF003300),
    secondaryContainer: Color(0xFF2E7D32),
    onSecondaryContainer: Color(0xFFC8E6C9),
    tertiary: accent,
    onTertiary: Color(0xFF003635),
    tertiaryContainer: Color(0xFF00504D),
    onTertiaryContainer: Color(0xFFB2DFDB),
    error: Color(0xFFCF6679),
    onError: Color(0xFF000000),
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFCDD2),
    surface: surfaceDark,
    onSurface: Color(0xFFE1E1E1),
    onSurfaceVariant: Color(0xFFB0B0B0),
    outline: dividerDark,
    outlineVariant: Color(0xFF424242),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: surfaceLight,
    onInverseSurface: textPrimary,
    inversePrimary: primaryGreen,
    surfaceTint: primaryGreenLight,
  );

  /// Business Card Colors
  static const Map<String, Color> businessCategories = {
    'restaurant': Color(0xFFFF5722),
    'shopping': Color(0xFF9C27B0),
    'services': primaryGreen,
    'healthcare': Color(0xFF2196F3),
    'automotive': Color(0xFF607D8B),
    'beauty': Color(0xFFE91E63),
    'education': Color(0xFF3F51B5),
    'entertainment': Color(0xFFFF9800),
    'finance': Color(0xFF4CAF50),
    'technology': Color(0xFF795548),
    'default': primaryGreen,
  };

  /// Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryGreenLight, primaryGreen],
    stops: [0.0, 1.0],
  );

  static const RadialGradient circularGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [gradientStart, gradientMiddle, gradientEnd],
    stops: [0.0, 0.6, 1.0],
  );

  /// Helper Methods
  static Color getCategoryColor(String category) {
    return businessCategories[category.toLowerCase()] ??
        businessCategories['default']!;
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'open':
      case 'online':
        return online;
      case 'inactive':
      case 'closed':
      case 'offline':
        return offline;
      case 'pending':
      case 'processing':
        return pending;
      default:
        return textSecondary;
    }
  }

  /// Material 3 inspired color utilities
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Semantic Colors
  static const Color positive = success;
  static const Color negative = error;
  static const Color neutral = textSecondary;
  static const Color link = Color(0xFF1976D2);
  static const Color visited = Color(0xFF7B1FA2);
}

/// Extension to add convenient methods to ColorScheme
extension AppColorSchemeExtension on ColorScheme {
  /// Get color for business category
  Color categoryColor(String category) =>
      AppColorScheme.getCategoryColor(category);

  /// Get color for status
  Color statusColor(String status) => AppColorScheme.getStatusColor(status);

  /// Business-specific surface colors
  Color get businessCardSurface =>
      brightness == Brightness.light
          ? AppColorScheme.cardBackground
          : AppColorScheme.cardBackgroundDark;

  /// Interactive surface colors
  Color get interactiveSurface =>
      brightness == Brightness.light
          ? AppColorScheme.ripple
          : AppColorScheme.splash;
}
