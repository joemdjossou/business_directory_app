import 'package:flutter/material.dart';

import '../../utils/constants.dart';

/// Empty state widget for when no data is available
class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;
  final bool isSearch;

  const EmptyStateWidget({
    Key? key,
    this.title,
    this.message,
    this.icon,
    this.onAction,
    this.actionText,
    this.isSearch = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.listPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Icon(
              icon ?? (isSearch ? Icons.search_off : Icons.business),
              size: 64.0,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
            const SizedBox(height: 16.0),

            // Empty state title
            Text(
              title ?? (isSearch ? 'No Results Found' : 'No Businesses'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),

            // Empty state message
            Text(
              message ??
                  (isSearch
                      ? AppConstants.searchNoResultsMessage
                      : AppConstants.noDataMessage),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(isSearch ? Icons.clear : Icons.refresh),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
