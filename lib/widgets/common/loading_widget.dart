import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Loading state widget with skeleton animation
class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool showSkeleton;

  const LoadingWidget({
    Key? key,
    this.message,
    this.showSkeleton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showSkeleton) ...[
            _buildSkeletonList(),
            const SizedBox(height: 24.0),
          ],
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16.0),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Column(
      children: List.generate(3, (index) => _buildSkeletonCard()),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.listPadding,
        vertical: 4.0,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          Container(
            height: 20.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: 8.0),
          
          // Location skeleton
          Container(
            height: 16.0,
            width: 200.0,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: 8.0),
          
          // Phone skeleton
          Container(
            height: 16.0,
            width: 150.0,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }
}
