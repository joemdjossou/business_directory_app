import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/business_provider.dart';
import '../utils/constants.dart';
import '../widgets/cards/business_card.dart';
import '../widgets/common/animated_fab.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/error_widget.dart' as custom;
import '../widgets/common/loading_widget.dart';
import 'business_detail_screen.dart';
import 'search_screen.dart';

/// Main business list screen with search and filtering
class BusinessListScreen extends StatefulWidget {
  const BusinessListScreen({super.key});

  @override
  State<BusinessListScreen> createState() => _BusinessListScreenState();
}

class _BusinessListScreenState extends State<BusinessListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load businesses when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessProvider>().loadBusinesses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Directory'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _navigateToSearch(),
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshBusinesses(),
          ),
        ],
      ),
      body: Consumer<BusinessProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: _buildBody(provider),
          );
        },
      ),
      floatingActionButton: Consumer<BusinessProvider>(
        builder: (context, provider, child) {
          if (provider.isOffline) {
            return AnimatedFAB(
              onPressed: () => _refreshBusinesses(),
              backgroundColor: Theme.of(context).colorScheme.error,
              tooltip: 'Retry Connection',
              child: const Icon(Icons.wifi_off),
            );
          }
          return ExpandableFAB(
            items: [
              FABMenuItem(
                icon: const Icon(Icons.search),
                label: 'Search',
                onPressed: _navigateToSearch,
              ),
              FABMenuItem(
                icon: const Icon(Icons.refresh),
                label: 'Refresh',
                onPressed: _refreshBusinesses,
              ),
              FABMenuItem(
                icon: const Icon(Icons.filter_list),
                label: 'Filter',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filter coming soon!')),
                  );
                },
              ),
            ],
            child: const Icon(Icons.menu),
          );
        },
      ),
    );
  }

  Widget _buildBody(BusinessProvider provider) {
    switch (provider.state) {
      case AppState.initial:
      case AppState.loading:
        return const LoadingWidget(message: 'Loading businesses...');

      case AppState.error:
        return custom.ErrorWidget(
          message: provider.errorMessage,
          onRetry: () => provider.retry(),
          isOffline: provider.isOffline,
        );

      case AppState.empty:
        return EmptyStateWidget(
          title:
              provider.searchQuery.isNotEmpty
                  ? 'No Results Found'
                  : 'No Businesses',
          message:
              provider.searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : 'No businesses are currently available',
          onAction:
              provider.searchQuery.isNotEmpty
                  ? () => provider.clearSearch()
                  : () => provider.retry(),
          actionText:
              provider.searchQuery.isNotEmpty ? 'Clear Search' : 'Retry',
          isSearch: provider.searchQuery.isNotEmpty,
        );

      case AppState.loaded:
      case AppState.refreshing:
        return _buildBusinessList(provider);
    }
  }

  Widget _buildBusinessList(BusinessProvider provider) {
    return Column(
      children: [
        // Search bar
        if (provider.searchQuery.isNotEmpty) _buildSearchBar(provider),

        // Business count and offline indicator
        _buildHeader(provider),

        // Business list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: provider.businesses.length,
            itemBuilder: (context, index) {
              final business = provider.businesses[index];
              return BusinessCard(
                business: business,
                index: index,
                onTap: () => _navigateToDetail(business),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BusinessProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.listPadding),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Search: "${provider.searchQuery}"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => provider.clearSearch(),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BusinessProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.listPadding,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${provider.businesses.length} business${provider.businesses.length != 1 ? 'es' : ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (provider.isOffline)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 14.0,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    'Offline',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetail(business) {
    context.read<BusinessProvider>().selectBusiness(business);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BusinessDetailScreen(business: business),
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _refreshBusinesses() {
    context.read<BusinessProvider>().refresh();
  }
}
