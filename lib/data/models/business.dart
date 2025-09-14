/// Business domain model with data validation and normalization
class Business {
  final String id;
  final String name;
  final String location;
  final String contactNumber;

  const Business({
    required this.id,
    required this.name,
    required this.location,
    required this.contactNumber,
  });

  /// Factory constructor to create Business from JSON with validation
  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: _generateId(json),
      name: _validateAndNormalize(json['biz_name']),
      location: _validateAndNormalize(json['bss_location']),
      contactNumber: _validateAndNormalize(json['contct_no']),
    );
  }

  /// Convert Business to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'contactNumber': contactNumber,
    };
  }

  /// Generate a unique ID from business data
  static String _generateId(Map<String, dynamic> json) {
    final name = json['biz_name']?.toString() ?? '';
    final location = json['bss_location']?.toString() ?? '';
    return '${name.toLowerCase().replaceAll(' ', '_')}_${location.toLowerCase().replaceAll(' ', '_')}';
  }

  /// Validate and normalize string data
  static String _validateAndNormalize(dynamic value) {
    if (value == null) {
      throw ValidationException('Required field is null');
    }

    final stringValue = value.toString().trim();
    if (stringValue.isEmpty) {
      throw ValidationException('Required field is empty');
    }

    return stringValue;
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    // Basic phone number validation - allows international formats
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(phoneNumber) && phoneNumber.length >= 10;
  }

  /// Validate business name
  static bool isValidBusinessName(String name) {
    return name.trim().isNotEmpty && name.length >= 2;
  }

  /// Validate location
  static bool isValidLocation(String location) {
    return location.trim().isNotEmpty && location.length >= 2;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Business &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.contactNumber == contactNumber;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, location, contactNumber);
  }

  @override
  String toString() {
    return 'Business(id: $id, name: $name, location: $location, contactNumber: $contactNumber)';
  }
}

/// Custom exception for validation errors
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}
