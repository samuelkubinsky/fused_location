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
              _buildInfoRow(
                "Latitude",
                "${location.position.latitude.toStringAsFixed(6)}°",
              ),
              _buildInfoRow(
                "Longitude",
                "${location.position.longitude.toStringAsFixed(6)}°",
              ),
              _buildInfoRow(
                "Accuracy",
                location.position.accuracy != null
                    ? "±${location.position.accuracy!.toStringAsFixed(1)}m"
                    : "N/A",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Elevation Card
          _buildSectionCard(
            context,
            icon: Icons.terrain,
            title: "Elevation",
            color: Colors.green,
            isAvailable: _hasElevationData(),
            children: [
              _buildInfoRow(
                "Mean Sea Level",
                location.elevation.meanSeaLevel != null
                    ? "${location.elevation.meanSeaLevel!.toStringAsFixed(1)}m"
                    : "N/A",
              ),
              _buildInfoRow(
                "Mean Sea Level Accuracy",
                location.elevation.meanSeaLevelAccuracy != null
                    ? "±${location.elevation.meanSeaLevelAccuracy!.toStringAsFixed(1)}m"
                    : "N/A",
              ),
              _buildInfoRow(
                "Ellipsoidal",
                location.elevation.ellipsoidal != null
                    ? "${location.elevation.ellipsoidal!.toStringAsFixed(1)}m"
                    : "N/A",
              ),
              _buildInfoRow(
                "Ellipsoidal Accuracy",
                location.elevation.ellipsoidalAccuracy != null
                    ? "±${location.elevation.ellipsoidalAccuracy!.toStringAsFixed(1)}m"
                    : "N/A",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Heading Card
          _buildSectionCard(
            context,
            icon: Icons.explore,
            title: "Heading",
            color: Colors.orange,
            isAvailable: true, // Heading is always available based on your model
            children: [
              _buildInfoRow(
                "Direction",
                "${location.heading.direction.toStringAsFixed(1)}°",
              ),
              _buildInfoRow(
                "Accuracy",
                "±${location.heading.accuracy.toStringAsFixed(1)}°",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Course Card
          _buildSectionCard(
            context,
            icon: Icons.navigation,
            title: "Course",
            color: Colors.purple,
            isAvailable: _hasCourseData(),
            children: [
              _buildInfoRow(
                "Direction",
                location.course.direction != null
                    ? "${location.course.direction!.toStringAsFixed(1)}°"
                    : "N/A",
              ),
              _buildInfoRow(
                "Accuracy",
                location.course.accuracy != null
                    ? "±${location.course.accuracy!.toStringAsFixed(1)}°"
                    : "N/A",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Speed Card
          _buildSectionCard(
            context,
            icon: Icons.speed,
            title: "Speed",
            color: Colors.red,
            isAvailable: _hasSpeedData(),
            children: [
              _buildInfoRow(
                "Magnitude",
                location.speed.magnitude != null
                    ? "${location.speed.magnitude!.toStringAsFixed(2)} m/s"
                    : "N/A",
              ),
              _buildInfoRow(
                "Accuracy",
                location.speed.accuracy != null
                    ? "±${location.speed.accuracy!.toStringAsFixed(2)} m/s"
                    : "N/A",
              ),
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
              _buildInfoRow(
                "Last Updated",
                location.timestamp.toIso8601String(),
              ),
            ],
          ),

          const SizedBox(height: 128),
        ],
      ),
    );
  }

  // Helper methods to check data availability
  bool _hasElevationData() {
    return location.elevation.meanSeaLevel != null || location.elevation.ellipsoidal != null;
  }

  bool _hasCourseData() {
    return location.course.direction != null || location.course.accuracy != null;
  }

  bool _hasSpeedData() {
    return location.speed.magnitude != null || location.speed.accuracy != null;
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
                if (!isAvailable) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Unavailable",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
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
    final isUnavailable = value == "N/A";

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isUnavailable ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isUnavailable ? Colors.grey[400] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
