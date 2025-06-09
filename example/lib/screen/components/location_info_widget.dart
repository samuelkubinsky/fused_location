import "package:flutter/material.dart";
import "package:fused_location/fused_location.dart";

class LocationInfoWidget extends StatelessWidget {
  final FusedLocation location;

  const LocationInfoWidget({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Position Card
          _buildSectionCard(
            context,
            icon: Icons.location_on,
            title: "Position",
            color: Colors.blue,
            isAvailable: true,
            children: [
              _buildInfoRow("Latitude", "${location.position.latitude.toStringAsFixed(6)}°"),
              _buildInfoRow("Longitude", "${location.position.longitude.toStringAsFixed(6)}°"),
              _buildInfoRow("Accuracy", "±${location.position.accuracy.toStringAsFixed(1)}m"),
            ],
          ),

          const SizedBox(height: 12),

          // Elevation Card
          _buildSectionCard(
            context,
            icon: Icons.terrain,
            title: "Elevation",
            color: Colors.green,
            isAvailable: true,
            children: [
              _buildInfoRow("Altitude", "${location.elevation.altitude.toStringAsFixed(1)}m"),
              _buildInfoRow("Accuracy", "±${location.elevation.accuracy.toStringAsFixed(1)}m"),
            ],
          ),

          const SizedBox(height: 12),

          // Heading Card
          _buildSectionCard(
            context,
            icon: Icons.explore,
            title: "Heading",
            color: Colors.orange,
            isAvailable: true,
            children: [
              _buildInfoRow("Direction", "${location.heading.direction.toStringAsFixed(1)}°"),
              _buildInfoRow("Accuracy", "±${location.heading.accuracy.toStringAsFixed(1)}°"),
            ],
          ),

          const SizedBox(height: 12),

          // Course Card
          _buildSectionCard(
            context,
            icon: Icons.navigation,
            title: "Course",
            color: Colors.purple,
            isAvailable: location.course != null,
            children: [
              _buildInfoRow("Direction", "${location.course?.direction.toStringAsFixed(1)}°"),
              _buildInfoRow("Accuracy", "±${location.course?.accuracy.toStringAsFixed(1)}°"),
            ],
          ),

          const SizedBox(height: 12),

          // Speed Card
          _buildSectionCard(
            context,
            icon: Icons.speed,
            title: "Speed",
            color: Colors.red,
            isAvailable: location.speed != null,
            children: [
              _buildInfoRow("Speed", "${location.speed?.magnitude.toStringAsFixed(2)} m/s"),
              _buildInfoRow("Accuracy", "±${location.speed?.accuracy.toStringAsFixed(2)} m/s"),
            ],
          ),

          const SizedBox(height: 12),

          // Timestamp Card
          _buildSectionCard(
            context,
            icon: Icons.access_time,
            title: "Timestamp",
            color: Colors.grey,
            isAvailable: true,
            children: [
              _buildInfoRow("Last Updated", location.timestamp.toIso8601String()),
            ],
          ),

          const SizedBox(height: 128),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required MaterialColor color,
    required bool isAvailable,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isAvailable ? color[700] : Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isAvailable ? color[700] : Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
