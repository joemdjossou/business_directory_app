import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business.dart';

/// Local storage service for offline persistence
class LocalStorageService {
  static const String _businessesKey = 'businesses_cache';
  static const String _lastUpdatedKey = 'last_updated';

  /// Save businesses to local storage
  Future<void> saveBusinesses(List<Business> businesses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = businesses.map((business) => business.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await prefs.setString(_businessesKey, jsonString);
    } catch (e) {
      throw StorageException('Failed to save businesses: ${e.toString()}');
    }
  }

  /// Get businesses from local storage
  Future<List<Business>> getBusinesses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_businessesKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList.map((json) => Business.fromJson(json)).toList();
    } catch (e) {
      throw StorageException('Failed to load businesses: ${e.toString()}');
    }
  }

  /// Save last updated timestamp
  Future<void> setLastUpdated(DateTime dateTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUpdatedKey, dateTime.toIso8601String());
    } catch (e) {
      throw StorageException('Failed to save last updated: ${e.toString()}');
    }
  }

  /// Get last updated timestamp
  Future<DateTime?> getLastUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString = prefs.getString(_lastUpdatedKey);
      
      if (dateString == null || dateString.isEmpty) {
        return null;
      }
      
      return DateTime.parse(dateString);
    } catch (e) {
      throw StorageException('Failed to load last updated: ${e.toString()}');
    }
  }

  /// Clear all businesses from storage
  Future<void> clearBusinesses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_businessesKey);
    } catch (e) {
      throw StorageException('Failed to clear businesses: ${e.toString()}');
    }
  }

  /// Clear last updated timestamp
  Future<void> clearLastUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastUpdatedKey);
    } catch (e) {
      throw StorageException('Failed to clear last updated: ${e.toString()}');
    }
  }

  /// Check if businesses are cached
  Future<bool> hasBusinesses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_businessesKey);
    } catch (e) {
      return false;
    }
  }

  /// Get cache size in bytes (approximate)
  Future<int> getCacheSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_businessesKey);
      return jsonString?.length ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Clear all app data
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw StorageException('Failed to clear all data: ${e.toString()}');
    }
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final hasData = await hasBusinesses();
      final lastUpdated = await getLastUpdated();
      final cacheSize = await getCacheSize();
      final businesses = await getBusinesses();
      
      return {
        'hasData': hasData,
        'lastUpdated': lastUpdated?.toIso8601String(),
        'cacheSize': cacheSize,
        'businessCount': businesses.length,
      };
    } catch (e) {
      return {
        'hasData': false,
        'lastUpdated': null,
        'cacheSize': 0,
        'businessCount': 0,
        'error': e.toString(),
      };
    }
  }
}

/// Custom exception for storage errors
class StorageException implements Exception {
  final String message;
  const StorageException(this.message);
  
  @override
  String toString() => 'StorageException: $message';
}
