import 'package:flutter/foundation.dart';
import '../data/models/business.dart';
import '../data/repositories/business_repository.dart';
import '../utils/constants.dart';

/// App state enumeration for clear state management
enum AppState {
  initial,
  loading,
  loaded,
  error,
  empty,
  refreshing,
}

/// Business provider for state management using Provider pattern
class BusinessProvider extends ChangeNotifier {
  final BusinessRepository _repository;
  
  // State variables
  List<Business> _businesses = [];
  List<Business> _filteredBusinesses = [];
  Business? _selectedBusiness;
  AppState _state = AppState.initial;
  String? _errorMessage;
  String _searchQuery = '';
  bool _isOffline = false;

  BusinessProvider(this._repository);

  // Getters
  List<Business> get businesses => _filteredBusinesses;
  List<Business> get allBusinesses => _businesses;
  Business? get selectedBusiness => _selectedBusiness;
  AppState get state => _state;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isOffline => _isOffline;
  bool get isLoading => _state == AppState.loading || _state == AppState.refreshing;
  bool get hasError => _state == AppState.error;
  bool get isEmpty => _state == AppState.empty;
  bool get isLoaded => _state == AppState.loaded;

  /// Load businesses from repository
  Future<void> loadBusinesses({bool forceRefresh = false}) async {
    try {
      if (_businesses.isEmpty || forceRefresh) {
        _setState(AppState.loading);
      } else {
        _setState(AppState.refreshing);
      }

      final businesses = await _repository.getBusinesses(forceRefresh: forceRefresh);
      
      if (businesses.isEmpty) {
        _setState(AppState.empty);
      } else {
        _businesses = businesses;
        _applySearch();
        _setState(AppState.loaded);
      }
      
      _isOffline = false;
    } catch (e) {
      _handleError(e);
    }
  }

  /// Search businesses by name and location
  void searchBusinesses(String query) {
    _searchQuery = query.trim();
    _applySearch();
  }

  /// Apply search filter to businesses
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredBusinesses = List.from(_businesses);
    } else {
      _filteredBusinesses = _businesses.where((business) {
        final nameMatch = business.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final locationMatch = business.location.toLowerCase().contains(_searchQuery.toLowerCase());
        return nameMatch || locationMatch;
      }).toList();
    }
    
    // Update state based on filtered results
    if (_filteredBusinesses.isEmpty && _searchQuery.isNotEmpty) {
      _setState(AppState.empty);
    } else if (_businesses.isNotEmpty) {
      _setState(AppState.loaded);
    }
    
    notifyListeners();
  }

  /// Select a business for detail view
  void selectBusiness(Business business) {
    _selectedBusiness = business;
    notifyListeners();
  }

  /// Clear search query
  void clearSearch() {
    _searchQuery = '';
    _applySearch();
  }

  /// Retry loading businesses
  Future<void> retry() async {
    await loadBusinesses(forceRefresh: true);
  }

  /// Refresh businesses data
  Future<void> refresh() async {
    await loadBusinesses(forceRefresh: true);
  }

  /// Set app state and notify listeners
  void _setState(AppState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Handle errors and set appropriate state
  void _handleError(dynamic error) {
    _errorMessage = _getErrorMessage(error);
    
    // If we have cached data, show it with offline indicator
    if (_businesses.isNotEmpty) {
      _isOffline = true;
      _setState(AppState.loaded);
    } else {
      _setState(AppState.error);
    }
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('network') || error.toString().contains('connection')) {
      return AppConstants.networkErrorMessage;
    } else if (error.toString().contains('validation')) {
      return 'Data validation error. Please check the data format.';
    } else if (error.toString().contains('parse')) {
      return 'Error parsing data. Please try again.';
    } else {
      return AppConstants.genericErrorMessage;
    }
  }

  /// Clear error state
  void clearError() {
    _errorMessage = null;
    if (_businesses.isNotEmpty) {
      _setState(AppState.loaded);
    } else {
      _setState(AppState.initial);
    }
  }

  /// Get business by ID
  Business? getBusinessById(String id) {
    try {
      return _businesses.firstWhere((business) => business.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get businesses by location
  List<Business> getBusinessesByLocation(String location) {
    return _businesses.where((business) => 
      business.location.toLowerCase().contains(location.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
