import "package:flutter/material.dart";
import "package:fused_location/fused_location.dart";
import "package:intl/intl.dart";

class LocationInfoWidget extends StatelessWidget {
  final FusedLocation location;

  const LocationInfoWidget({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final positionCard = _buildSectionCard(
      context,
      iconData: Icons.location_on,
      title: "Position",
      color: Colors.blue,
      isAvailable: true,
      children: [
        _buildInfoRow(
          label: "Latitude",
          value: location.position.latitude,
          valueFormatter: (value) => "${value.toStringAsFixed(6)}°",
        ),
        _buildInfoRow(
          label: "Longitude",
          value: location.position.longitude,
          valueFormatter: (value) => "${value.toStringAsFixed(6)}°",
        ),
        _buildInfoRow(
          label: "Accuracy",
          value: location.position.accuracy,
          valueFormatter: (value) => "±${value.toStringAsFixed(1)}m",
        ),
      ],
    );

    final elevationCard = _buildSectionCard(
      context,
      iconData: Icons.terrain,
      title: "Elevation",
      color: Colors.green,
      isAvailable: _hasElevationData(),
      children: [
        _buildInfoRow(
          label: "Mean Sea Level",
          value: location.elevation.meanSeaLevel,
          valueFormatter: (value) => "${value.toStringAsFixed(1)}m",
        ),
        _buildInfoRow(
          label: "Mean Sea Level Accuracy",
          value: location.elevation.meanSeaLevelAccuracy,
          valueFormatter: (value) => "±${value.toStringAsFixed(1)}m",
        ),
        _buildInfoRow(
          label: "Ellipsoidal",
          value: location.elevation.ellipsoidal,
          valueFormatter: (value) => "${value.toStringAsFixed(1)}m",
        ),
        _buildInfoRow(
          label: "Ellipsoidal Accuracy",
          value: location.elevation.ellipsoidalAccuracy,
          valueFormatter: (value) => "±${value.toStringAsFixed(1)}m",
        ),
      ],
    );

    final courseCard = _buildSectionCard(
      context,
      iconData: Icons.navigation,
      title: "Course",
      color: Colors.purple,
      isAvailable: _hasCourseData(),
      children: [
        _buildInfoRow(
          label: "Direction",
          value: location.course.direction,
          valueFormatter: (value) => "${value.toStringAsFixed(1)}°",
        ),
        _buildInfoRow(
          label: "Accuracy",
          value: location.course.accuracy,
          valueFormatter: (value) => "±${value.toStringAsFixed(1)}°",
        ),
      ],
    );

    final speedCard = _buildSectionCard(
      context,
      iconData: Icons.speed,
      title: "Speed",
      color: Colors.red,
      isAvailable: _hasSpeedData(),
      children: [
        _buildInfoRow(
          label: "Magnitude",
          value: location.speed.magnitude,
          valueFormatter: (value) => "${value.toStringAsFixed(2)} m/s",
        ),
        _buildInfoRow(
          label: "Accuracy",
          value: location.speed.accuracy,
          valueFormatter: (value) => "±${value.toStringAsFixed(2)} m/s",
        ),
      ],
    );

    final headingCard = _buildSectionCard(
      context,
      iconData: Icons.explore,
      title: "Heading",
      color: Colors.orange,
      isAvailable: true,
      children: [
        _buildInfoRow(
          label: "Direction",
          value: location.heading.direction,
          valueFormatter: (value) => "${value.toStringAsFixed(1)}°",
        ),
        _buildInfoRow(
          label: "Accuracy",
          value: location.heading.accuracy,
          valueFormatter: (value) => "±${value.toStringAsFixed(1)}°",
        ),
      ],
    );

    final timestampCard = _buildSectionCard(
      context,
      iconData: Icons.access_time,
      title: "Timestamp",
      color: Colors.grey,
      isAvailable: true,
      children: [
        _buildInfoRow(
          label: "Last Updated",
          value: location.timestamp.millisecondsSinceEpoch.toDouble(),
          valueFormatter: (value) => DateFormat("HH:mm:ss.SSS").format(
            DateTime.fromMillisecondsSinceEpoch(value.toInt()),
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 12,
        children: [
          positionCard,
          elevationCard,
          courseCard,
          speedCard,
          headingCard,
          timestampCard,
          const SizedBox(height: 128),
        ],
      ),
    );
  }

  // Helper methods to check data availability
  bool _hasElevationData() {
    return location.elevation.meanSeaLevel != null ||
        location.elevation.ellipsoidal != null;
  }

  bool _hasCourseData() {
    return location.course.direction != null ||
        location.course.accuracy != null;
  }

  bool _hasSpeedData() {
    return location.speed.magnitude != null || location.speed.accuracy != null;
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData iconData,
    required String title,
    required MaterialColor color,
    required bool isAvailable,
    required List<Widget> children,
  }) {
    final icon = Icon(
      iconData,
      color: isAvailable ? color[700] : Colors.grey[400],
      size: 24,
    );

    final text = Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: isAvailable ? color[700] : Colors.grey[400],
      ),
    );

    final unavailablePill = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
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
    );

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                icon,
                text,
                if (!isAvailable) unavailablePill,
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required double? value,
    required String Function(double) valueFormatter,
  }) {
    final isUnavailable = value == null;

    final labelText = Text(
      label,
      style: TextStyle(
        fontSize: 14,
        color: isUnavailable ? Colors.grey[400] : Colors.grey[600],
      ),
    );

    final valueText = Text(
      isUnavailable ? "N/A" : valueFormatter(value),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isUnavailable ? Colors.grey[400] : Colors.black87,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          labelText,
          valueText,
        ],
      ),
    );
  }
}
