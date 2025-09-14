import 'package:flutter/material.dart';

import '../../utils/constants.dart';

/// Error state widget with retry functionality
class ErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final bool isOffline;

  const ErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.listPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Icon(
              isOffline ? Icons.wifi_off : Icons.error_outline,
              size: 64.0,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16.0),

            // Error title
            Text(
              isOffline ? 'Offline Mode' : 'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),

            // Error message
            Text(
              message ??
                  (isOffline
                      ? 'You\'re currently offline. Some features may not be available.'
                      : AppConstants.genericErrorMessage),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Retry button
            if (onRetry != null && !isOffline) ...[
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],

            // Offline indicator
            if (isOffline) ...[
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 16.0,
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
          ],
        ),
      ),
    );
  }
}
