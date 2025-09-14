import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';

/// API service using Dio for network requests
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio();
    _setupInterceptors();
  }

  /// Setup Dio interceptors for logging and error handling
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            'Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('Error: ${error.message}');
          handler.next(error);
        },
      ),
    );

    // Add timeout interceptor
    _dio.options.connectTimeout = AppConstants.apiTimeout;
    _dio.options.receiveTimeout = AppConstants.apiTimeout;
  }

  /// Get businesses from local JSON file (simulating API call)
  Future<List<Map<String, dynamic>>> getBusinesses() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Load from local JSON file
      final jsonString = await rootBundle.loadString(
        'lib/data/local/businesses.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      // Convert to List<Map<String, dynamic>>
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      throw ApiException('Failed to load businesses: ${e.toString()}');
    }
  }

  /// Get business by ID (for future API integration)
  Future<Map<String, dynamic>> getBusinessById(String id) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));

      final businesses = await getBusinesses();
      final business = businesses.firstWhere(
        (b) => b['id'] == id,
        orElse: () => throw ApiException('Business not found'),
      );

      return business;
    } catch (e) {
      throw ApiException('Failed to get business: ${e.toString()}');
    }
  }

  /// Search businesses (for future API integration)
  Future<List<Map<String, dynamic>>> searchBusinesses(String query) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 400));

      final businesses = await getBusinesses();
      final normalizedQuery = query.toLowerCase();

      return businesses.where((business) {
        final name = business['biz_name']?.toString().toLowerCase() ?? '';
        final location =
            business['bss_location']?.toString().toLowerCase() ?? '';
        return name.contains(normalizedQuery) ||
            location.contains(normalizedQuery);
      }).toList();
    } catch (e) {
      throw ApiException('Failed to search businesses: ${e.toString()}');
    }
  }

  /// Get businesses by location (for future API integration)
  Future<List<Map<String, dynamic>>> getBusinessesByLocation(
    String location,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 400));

      final businesses = await getBusinesses();
      final normalizedLocation = location.toLowerCase();

      return businesses.where((business) {
        final businessLocation =
            business['bss_location']?.toString().toLowerCase() ?? '';
        return businessLocation.contains(normalizedLocation);
      }).toList();
    } catch (e) {
      throw ApiException(
        'Failed to get businesses by location: ${e.toString()}',
      );
    }
  }

  /// Simulate network error for testing
  Future<void> simulateNetworkError() async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw ApiException('Simulated network error');
  }

  /// Check network connectivity (for future implementation)
  Future<bool> isConnected() async {
    try {
      // Simulate network check
      await Future.delayed(const Duration(milliseconds: 100));
      return true; // For now, always return true since we're using local data
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _dio.close();
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
