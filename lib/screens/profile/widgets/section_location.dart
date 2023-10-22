import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final String location;

  const LocationSection({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return _buildLocationSection(context);
  }

  Widget _buildLocationSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('location'),
            style: AppTextStyles.titleLargeBlackBold(context),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              const Icon(Icons.location_on, size: 12),
              const SizedBox(width: 4),
              Text(
                location,
                style: AppTextStyles.bodyStyle(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
