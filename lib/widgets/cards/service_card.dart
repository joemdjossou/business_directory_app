import 'package:flutter/material.dart';

import '../../data/models/service.dart';
import 'base_card.dart';

/// Service-specific card implementation for future extensibility
class ServiceCard extends BaseCard<Service> {
  const ServiceCard({
    super.key,
    required Service service,
    super.onTap,
    super.padding,
    super.margin,
    super.elevation,
    super.borderRadius,
  }) : super(item: service);

  @override
  Widget buildContent(BuildContext context, Service service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Service name
        Text(
          service.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8.0),

        // Category
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            service.category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8.0),

        // Description
        Text(
          service.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),

        // Price
        if (service.price != null) ...[
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '\$${service.price!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],

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
  String getTitle(Service service) {
    return service.name;
  }

  @override
  String? getSubtitle(Service service) {
    return '${service.category} • ${service.price != null ? '\$${service.price!.toStringAsFixed(2)}' : 'Price not available'}';
  }
}
