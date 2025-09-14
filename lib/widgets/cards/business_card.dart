import 'package:flutter/material.dart';

import '../../data/models/business.dart';
import 'base_card.dart';

/// Business-specific card implementation
class BusinessCard extends BaseCard<Business> {
  const BusinessCard({
    super.key,
    required Business business,
    super.onTap,
    super.padding,
    super.margin,
    super.elevation,
    super.borderRadius,
  }) : super(item: business);

  @override
  Widget buildContent(BuildContext context, Business business) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business name
        Text(
          business.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8.0),

        // Location
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16.0,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                business.location,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),

        // Contact number
        Row(
          children: [
            Icon(
              Icons.phone,
              size: 16.0,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                business.contactNumber,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // Action indicator
        if (onTap != null) ...[
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'View Details',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4.0),
              Icon(
                Icons.arrow_forward_ios,
                size: 12.0,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  String getTitle(Business business) {
    return business.name;
  }

  @override
  String? getSubtitle(Business business) {
    return '${business.location} • ${business.contactNumber}';
  }
}
