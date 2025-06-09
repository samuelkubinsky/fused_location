import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:fused_location/fused_location.dart";
import "package:fused_location/fused_location_options.dart";

import "fused_location_platform_interface.dart";

/// An implementation of [FusedLocationPlatformInterface] that uses method channels.
class FusedLocationMethodChannel extends FusedLocationPlatformInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel("fused_location");

  @visibleForTesting
  final eventChannel = const EventChannel("fused_location/stream");

  Stream<FusedLocation>? _dataStream;

  @override
  Stream<FusedLocation> get dataStream {
    _dataStream ??= eventChannel.receiveBroadcastStream().map(parseNativeStreamData);
    return _dataStream!;
  }

  @override
  Future<void> startLocationUpdates({required FusedLocationProviderOptions options}) {
    return methodChannel.invokeMethod<void>("startLocationUpdates", options.toJson());
  }

  @override
  Future<void> stopLocationUpdates() {
    return methodChannel.invokeMethod<void>("stopLocationUpdates");
  }

  FusedLocation parseNativeStreamData(dynamic data) {
    if (data is! List) {
      throw ArgumentError("Expected list, got ${data.runtimeType}");
    }

    final list = data.cast<double>();

    if (list.length != 11) {
      throw ArgumentError("Expected 11 values in data list, got ${list.length}");
    }

    final position = Position(
      latitude: list[0],
      longitude: list[1],
      accuracy: list[2],
    );

    final elevation = Elevation(
      altitude: list[3],
      accuracy: list[4],
    );

    final heading = Heading(
      direction: list[5],
      accuracy: list[6],
    );

    final course = list[7] == -1
        ? null
        : Course(
            direction: list[7],
            accuracy: list[8],
          );

    final speed = list[9] == -1
        ? null
        : Speed(
            magnitude: list[9],
            accuracy: list[10],
          );

    final timestamp = DateTime.now();

    return FusedLocation(
      position: position,
      elevation: elevation,
      heading: heading,
      course: course,
      speed: speed,
      timestamp: timestamp,
    );
  }
}
