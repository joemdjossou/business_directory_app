import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../models/business.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

/// Repository pattern for business data access
class BusinessRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  BusinessRepository(this._apiService, this._localStorageService);

  /// Get businesses with offline-first strategy
  Future<List<Business>> getBusinesses({bool forceRefresh = false}) async {
    try {
      // Try to get fresh data first if force refresh or no cache
      if (forceRefresh || !await _hasValidCache()) {
        try {
          final freshData = await _apiService.getBusinesses();
          final businesses = _parseBusinesses(freshData);

          // Cache the fresh data
          await _localStorageService.saveBusinesses(businesses);
          await _localStorageService.setLastUpdated(DateTime.now());

          return businesses;
        } catch (e) {
          // If fresh data fails, try to load from cache
          final cachedBusinesses = await _localStorageService.getBusinesses();
          if (cachedBusinesses.isNotEmpty) {
            return cachedBusinesses;
          }
          rethrow;
        }
      } else {
        // Load from cache first, then refresh in background
        final cachedBusinesses = await _localStorageService.getBusinesses();

        // Refresh in background if cache is old
        if (await _isCacheStale()) {
          _refreshInBackground();
        }

        return cachedBusinesses;
      }
    } catch (e) {
      // Fallback to cache if available
      final cachedBusinesses = await _localStorageService.getBusinesses();
      if (cachedBusinesses.isNotEmpty) {
        return cachedBusinesses;
      }
      rethrow;
    }
  }

  /// Parse raw JSON data into Business objects with validation
  List<Business> _parseBusinesses(List<Map<String, dynamic>> rawData) {
    final businesses = <Business>[];

    for (final json in rawData) {
      try {
        // Validate JSON structure
        if (!Validators.isValidBusinessJson(json)) {
          throw ValidationException('Invalid business data structure: $json');
        }

        // Create and validate business object
        final business = Business.fromJson(json);

        // Additional validation
        if (!Validators.isValidBusinessName(business.name)) {
          throw ValidationException('Invalid business name: ${business.name}');
        }

        if (!Validators.isValidLocation(business.location)) {
          throw ValidationException('Invalid location: ${business.location}');
        }

        if (!Validators.isValidPhoneNumber(business.contactNumber)) {
          throw ValidationException(
            'Invalid phone number: ${business.contactNumber}',
          );
        }

        businesses.add(business);
      } catch (e) {
        // Log validation errors but continue processing other businesses
        debugPrint('Error parsing business data: $e');
        continue;
      }
    }

    if (businesses.isEmpty) {
      throw Exception('No valid businesses found in data');
    }

    return businesses;
  }

  /// Check if we have valid cached data
  Future<bool> _hasValidCache() async {
    try {
      final businesses = await _localStorageService.getBusinesses();
      return businesses.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Check if cache is stale and needs refresh
  Future<bool> _isCacheStale() async {
    try {
      final lastUpdated = await _localStorageService.getLastUpdated();
      if (lastUpdated == null) return true;

      final now = DateTime.now();
      final difference = now.difference(lastUpdated);
      return difference > AppConstants.cacheExpiry;
    } catch (e) {
      return true;
    }
  }

  /// Refresh data in background without blocking UI
  void _refreshInBackground() {
    Future.delayed(Duration.zero, () async {
      try {
        final freshData = await _apiService.getBusinesses();
        final businesses = _parseBusinesses(freshData);

        await _localStorageService.saveBusinesses(businesses);
        await _localStorageService.setLastUpdated(DateTime.now());
      } catch (e) {
        // Background refresh failed, but we don't want to disrupt the user
        debugPrint('Background refresh failed: $e');
      }
    });
  }

  /// Get business by ID
  Future<Business?> getBusinessById(String id) async {
    try {
      final businesses = await getBusinesses();
      return businesses.firstWhere((business) => business.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search businesses by query
  Future<List<Business>> searchBusinesses(String query) async {
    if (!Validators.isValidSearchQuery(query)) {
      return [];
    }

    try {
      final businesses = await getBusinesses();
      final normalizedQuery = Validators.sanitizeInput(query).toLowerCase();

      return businesses.where((business) {
        final nameMatch = business.name.toLowerCase().contains(normalizedQuery);
        final locationMatch = business.location.toLowerCase().contains(
          normalizedQuery,
        );
        return nameMatch || locationMatch;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get businesses by location
  Future<List<Business>> getBusinessesByLocation(String location) async {
    try {
      final businesses = await getBusinesses();
      final normalizedLocation =
          Validators.sanitizeInput(location).toLowerCase();

      return businesses
          .where(
            (business) =>
                business.location.toLowerCase().contains(normalizedLocation),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _localStorageService.clearBusinesses();
    await _localStorageService.clearLastUpdated();
  }
}
