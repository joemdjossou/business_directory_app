import 'package:flutter/foundation.dart';

/// Service domain model for future extensibility
class Service {
  final String id;
  final String name;
  final String description;
  final String category;
  final double? price;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.price,
  });

  /// Factory constructor to create Service from JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: json['price']?.toDouble(),
    );
  }

  /// Convert Service to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Service &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.category == category &&
        other.price == price;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, description, category, price);
  }

  @override
  String toString() {
    return 'Service(id: $id, name: $name, description: $description, category: $category, price: $price)';
  }
}
