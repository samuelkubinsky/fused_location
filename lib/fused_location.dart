class FusedLocation {
  const FusedLocation({
    required this.position,
    required this.elevation,
    required this.course,
    required this.speed,
    required this.heading,
    required this.timestamp,
  });

  final Position position;
  final Elevation elevation;
  final Course course;
  final Speed speed;
  final Heading heading;
  final DateTime timestamp;

  FusedLocation.fromJson(Map<String, double> json)
    : this(
        position: Position.fromJson(json),
        elevation: Elevation.fromJson(json),
        course: Course.fromJson(json),
        speed: Speed.fromJson(json),
        heading: Heading.fromJson(json),
        timestamp: DateTime.now(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FusedLocation &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          elevation == other.elevation &&
          course == other.course &&
          speed == other.speed &&
          heading == other.heading &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(
    position,
    elevation,
    course,
    speed,
    heading,
    timestamp,
  );

  @override
  String toString() {
    return "FusedLocationData("
        "position: $position, "
        "elevation: $elevation, "
        "course: $course, "
        "speed: $speed, "
        "heading: $heading, "
        "timestamp: $timestamp"
        ")";
  }
}

class Position {
  const Position({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees.
  final double longitude;

  /// The radius of uncertainty for the location, measured in meters.
  final double? accuracy;

  Position.fromJson(Map<String, double> json)
    : this(
        latitude: json["positionLatitude"]!,
        longitude: json["positionLongitude"]!,
        accuracy: json["positionAccuracy"] == -1
            ? null
            : json["positionAccuracy"]!,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(
    latitude,
    longitude,
    accuracy,
  );

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
    this.meanSeaLevel,
    this.meanSeaLevelAccuracy,
    this.ellipsoidal,
    this.ellipsoidalAccuracy,
  });

  /// The altitude above mean sea level associated with a location,
  /// measured in meters.
  final double? meanSeaLevel;

  /// The estimated uncertainty of the mean sea level altitude,
  /// measured in meters.
  final double? meanSeaLevelAccuracy;

  /// The altitude as a height above the World Geodetic System 1984 (WGS84)
  /// ellipsoid, measured in meters.
  final double? ellipsoidal;

  /// The estimated uncertainty of the ellipsoidal altitude, measured in meters.
  final double? ellipsoidalAccuracy;

  Elevation.fromJson(Map<String, double> json)
    : this(
        meanSeaLevel: json["elevationMeanSeaLevel"] == -1
            ? null
            : json["elevationMeanSeaLevel"]!,
        meanSeaLevelAccuracy: json["elevationMeanSeaLevelAccuracy"] == -1
            ? null
            : json["elevationMeanSeaLevelAccuracy"]!,
        ellipsoidal: json["elevationEllipsoidal"] == -1
            ? null
            : json["elevationEllipsoidal"]!,
        ellipsoidalAccuracy: json["elevationEllipsoidalAccuracy"] == -1
            ? null
            : json["elevationEllipsoidalAccuracy"]!,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Elevation &&
          runtimeType == other.runtimeType &&
          meanSeaLevel == other.meanSeaLevel &&
          meanSeaLevelAccuracy == other.meanSeaLevelAccuracy &&
          ellipsoidal == other.ellipsoidal &&
          ellipsoidalAccuracy == other.ellipsoidalAccuracy;

  @override
  int get hashCode => Object.hash(
    meanSeaLevel,
    meanSeaLevelAccuracy,
    ellipsoidal,
    ellipsoidalAccuracy,
  );

  @override
  String toString() {
    return "Elevation("
        "meanSeaLevel: $meanSeaLevel, "
        "meanSeaLevelAccuracy: $meanSeaLevelAccuracy, "
        "ellipsoidal: $ellipsoidal, "
        "ellipsoidalAccuracy: $ellipsoidalAccuracy"
        ")";
  }
}

class Course {
  const Course({
    this.direction,
    this.accuracy,
  });

  /// The direction in which the device is traveling, measured in degrees
  /// and relative to due north.
  final double? direction;

  /// The accuracy of the course value, measured in degrees.
  final double? accuracy;

  Course.fromJson(Map<String, double> json)
    : this(
        direction: json["courseDirection"] == -1
            ? null
            : json["courseDirection"]!,
        accuracy: json["courseAccuracy"] == -1 ? null : json["courseAccuracy"]!,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(
    direction,
    accuracy,
  );

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
    this.magnitude,
    this.accuracy,
  });

  /// The instantaneous speed of the device, measured in meters per second.
  final double? magnitude;

  /// The accuracy of the speed value, measured in meters per second.
  final double? accuracy;

  Speed.fromJson(Map<String, double> json)
    : this(
        magnitude: json["speedMagnitude"] == -1
            ? null
            : json["speedMagnitude"]!,
        accuracy: json["speedAccuracy"] == -1 ? null : json["speedAccuracy"]!,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Speed &&
          runtimeType == other.runtimeType &&
          magnitude == other.magnitude &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(
    magnitude,
    accuracy,
  );

  @override
  String toString() {
    return "Speed("
        "speed: $magnitude, "
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

  /// The maximum deviation (measured in degrees) between the reported heading
  /// and the true geomagnetic heading.
  final double accuracy;

  Heading.fromJson(Map<String, double> json)
    : this(
        direction: json["headingDirection"]!,
        accuracy: json["headingAccuracy"]!,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Heading &&
          runtimeType == other.runtimeType &&
          direction == other.direction &&
          accuracy == other.accuracy;

  @override
  int get hashCode => Object.hash(
    direction,
    accuracy,
  );

  @override
  String toString() {
    return "Heading("
        "direction: $direction, "
        "accuracy: $accuracy"
        ")";
  }
}
