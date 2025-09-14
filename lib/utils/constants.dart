/// Application constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Local Storage Keys
  static const String businessesCacheKey = 'businesses_cache';
  static const String lastUpdatedKey = 'last_updated';

  // Cache Configuration
  static const Duration cacheExpiry = Duration(hours: 24);

  // Search Configuration
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);

  // UI Configuration
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 8.0;
  static const double listPadding = 16.0;

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String noDataMessage = 'No businesses found.';
  static const String searchNoResultsMessage =
      'No businesses match your search.';

  // Success Messages
  static const String dataLoadedMessage = 'Businesses loaded successfully.';
  static const String cacheUpdatedMessage = 'Data updated from cache.';
}
