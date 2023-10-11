import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final String location;

  const LocationSection({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return _buildLocationSection();
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Localisation",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Icon(Icons.location_on, size: 12),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
