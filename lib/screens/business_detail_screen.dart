import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/business.dart';
import '../utils/constants.dart';

/// Business detail screen showing full business information
class BusinessDetailScreen extends StatelessWidget {
  final Business business;

  const BusinessDetailScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          business.name,
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareBusiness(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.listPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business header card
            _buildHeaderCard(context),
            const SizedBox(height: 16.0),

            // Contact information card
            _buildContactCard(context),
            const SizedBox(height: 16.0),

            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business name
            Text(
              business.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),

            // Business ID (for debugging)
            Text(
              'ID: ${business.id}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Location
            _buildInfoRow(
              context,
              icon: Icons.location_on,
              label: 'Location',
              value: business.location,
            ),
            const SizedBox(height: 12.0),

            // Phone number
            _buildInfoRow(
              context,
              icon: Icons.phone,
              label: 'Phone',
              value: business.contactNumber,
              isClickable: true,
              onTap: () => _makePhoneCall(context, business.contactNumber),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isClickable ? onTap : null,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20.0,
              color:
                  isClickable
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color:
                          isClickable
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onSurface,
                      fontWeight:
                          isClickable ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isClickable)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Call button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall(context, business.contactNumber),
            icon: const Icon(Icons.phone),
            label: const Text('Call Business'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12.0),

        // Copy contact info button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _copyContactInfo(context),
            icon: const Icon(Icons.copy),
            label: const Text('Copy Contact Info'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _makePhoneCall(BuildContext context, String phoneNumber) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          _showSnackBar(context, 'Could not make phone call');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Error making phone call: $e');
      }
    }
  }

  void _copyContactInfo(BuildContext context) {
    final contactInfo = '''
${business.name}
${business.location}
${business.contactNumber}
''';

    Clipboard.setData(ClipboardData(text: contactInfo));
    _showSnackBar(context, 'Contact info copied to clipboard');
  }

  void _shareBusiness(BuildContext context) {
    final shareText = '''
Check out ${business.name}!
📍 ${business.location}
📞 ${business.contactNumber}
''';

    // For now, just copy to clipboard
    // In a real app, you'd use a share plugin
    Clipboard.setData(ClipboardData(text: shareText));
    _showSnackBar(context, 'Business info copied to clipboard');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
