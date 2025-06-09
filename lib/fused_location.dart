class FusedLocation {
  const FusedLocation({
    required this.position,
    required this.elevation,
    required this.heading,
    this.course,
    this.speed,
    required this.timestamp,
  });

  final Position position;
  final Elevation elevation;
  final Heading heading;
  final Course? course;
  final Speed? speed;
  final DateTime timestamp;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FusedLocation &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          elevation == other.elevation &&
          heading == other.heading &&
          course == other.course &&
          speed == other.speed &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(
    position,
    elevation,
    heading,
    course,
    speed,
    timestamp,
  );

  @override
  String toString() {
    return "FusedLocationData("
        "position: $position, "
        "elevation: $elevation, "
        "heading: $heading, "
        "course: $course, "
        "speed: $speed, "
        "timestamp: $timestamp"
        ")";
  }
}

class Position {
  const Position({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees.
  final double longitude;

  /// The radius of uncertainty for the location, measured in meters.
  final double accuracy;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(latitude, longitude, accuracy);

  @override
  String toString() {
    return "Position("
        "latitude: $latitude, "
        "longitude: $longitude, "
        "accuracy: $accuracy"
        ")";
  }
}

class Elevation {
  const Elevation({
    required this.altitude,
    required this.accuracy,
  });

  /// The altitude above mean sea level associated with a location, measured in meters.
  final double altitude;

  /// The validity of the altitude values, and their estimated uncertainty, measured in meters.
  final double accuracy;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Elevation &&
          runtimeType == other.runtimeType &&
          altitude == other.altitude &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(altitude, accuracy);

  @override
  String toString() {
    return "Elevation("
        "altitude: $altitude, "
        "accuracy: $accuracy"
        ")";
  }
}

class Heading {
  const Heading({
    required this.direction,
    required this.accuracy,
  });

  /// The heading (measured in degrees) relative to true north.
  final double direction;

  /// The maximum deviation (measured in degrees) between the reported heading and the true geomagnetic heading.
  final double accuracy;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Heading &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(direction, accuracy);

  @override
  String toString() {
    return "Heading("
        "direction: $direction, "
        "accuracy: $accuracy"
        ")";
  }
}

class Course {
  const Course({
    required this.direction,
    required this.accuracy,
  });

  /// The direction in which the device is traveling, measured in degrees and relative to due north.
  final double direction;

  /// The accuracy of the course value, measured in degrees.
  final double accuracy;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(direction, accuracy);

  @override
  String toString() {
    return "Course("
        "direction: $direction, "
        "accuracy: $accuracy"
        ")";
  }
}

class Speed {
  const Speed({
    required this.magnitude,
    required this.accuracy,
  });

  /// The instantaneous speed of the device, measured in meters per second.
  final double magnitude;

  /// The accuracy of the speed value, measured in meters per second.
  final double accuracy;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Speed &&
          runtimeType == other.runtimeType &&
          magnitude == other.magnitude &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(magnitude, accuracy);

  @override
  String toString() {
    return "Speed("
        "speed: $magnitude, "
        "accuracy: $accuracy"
        ")";
  }
}
