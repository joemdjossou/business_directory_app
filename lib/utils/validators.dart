/// Validation utilities for data integrity
class Validators {
  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters except +
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Check if it starts with + and has at least 10 digits
    if (cleaned.startsWith('+')) {
      return cleaned.length >= 11; // +1 + country code + number
    }
    
    // Check if it's a local number with at least 10 digits
    return cleaned.length >= 10;
  }

  /// Validate business name
  static bool isValidBusinessName(String name) {
    final trimmed = name.trim();
    return trimmed.isNotEmpty && 
           trimmed.length >= 2 && 
           trimmed.length <= 100 &&
           !trimmed.contains(RegExp(r'[<>{}]')); // Basic XSS prevention
  }

  /// Validate location
  static bool isValidLocation(String location) {
    final trimmed = location.trim();
    return trimmed.isNotEmpty && 
           trimmed.length >= 2 && 
           trimmed.length <= 100;
  }

  /// Validate search query
  static bool isValidSearchQuery(String query) {
    final trimmed = query.trim();
    return trimmed.isNotEmpty && trimmed.length >= 1;
  }

  /// Sanitize input string
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Normalize phone number
  static String normalizePhoneNumber(String phoneNumber) {
    // Remove all non-digit characters except +
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If it doesn't start with +, assume it's a local number
    if (!cleaned.startsWith('+')) {
      return '+1$cleaned'; // Default to US country code
    }
    
    return cleaned;
  }

  /// Validate JSON structure for business data
  static bool isValidBusinessJson(Map<String, dynamic> json) {
    return json.containsKey('biz_name') &&
           json.containsKey('bss_location') &&
           json.containsKey('contct_no') &&
           json['biz_name'] != null &&
           json['bss_location'] != null &&
           json['contct_no'] != null;
  }
}
