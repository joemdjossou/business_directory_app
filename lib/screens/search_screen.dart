import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/business_provider.dart';
import '../utils/constants.dart';
import '../widgets/cards/business_card.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/loading_widget.dart';
import 'business_detail_screen.dart';

/// Search screen with real-time search functionality
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Focus on search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Businesses'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Search results
          Expanded(
            child: Consumer<BusinessProvider>(
              builder: (context, provider, child) {
                return _buildSearchResults(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.listPadding),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Search input field
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search by name or location...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            onSubmitted: _onSearchSubmitted,
          ),

          // Search suggestions
          if (_searchController.text.isEmpty) _buildSearchSuggestions(),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search suggestions:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              _buildSuggestionChip('Salon'),
              _buildSuggestionChip('Barbershop'),
              _buildSuggestionChip('Kitchen'),
              _buildSuggestionChip('Atlanta'),
              _buildSuggestionChip('Lagos'),
              _buildSuggestionChip('Accra'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _searchController.text = text;
        _onSearchChanged(text);
      },
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSearchResults(BusinessProvider provider) {
    if (_searchController.text.isEmpty) {
      return _buildEmptySearchState();
    }

    if (provider.isLoading) {
      return const LoadingWidget(message: 'Searching...', showSkeleton: false);
    }

    if (provider.businesses.isEmpty) {
      return EmptyStateWidget(
        title: 'No Results Found',
        message: 'Try different search terms or check your spelling',
        onAction: _clearSearch,
        actionText: 'Clear Search',
        isSearch: true,
      );
    }

    return Column(
      children: [
        // Results header
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.listPadding,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${provider.businesses.length} result${provider.businesses.length != 1 ? 's' : ''} for "${_searchController.text}"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: provider.businesses.length,
            itemBuilder: (context, index) {
              final business = provider.businesses[index];
              return BusinessCard(
                business: business,
                onTap: () => _navigateToDetail(business),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.listPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64.0,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Search Businesses',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Enter a business name or location to search',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {});
    context.read<BusinessProvider>().searchBusinesses(query);
  }

  void _onSearchSubmitted(String query) {
    _searchFocusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
    context.read<BusinessProvider>().clearSearch();
  }

  void _navigateToDetail(business) {
    context.read<BusinessProvider>().selectBusiness(business);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessDetailScreen(business: business),
      ),
    );
  }
}
