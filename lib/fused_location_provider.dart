import "package:fused_location/fused_location_options.dart";
import "package:fused_location/fused_location.dart";

import "src/fused_location_platform_interface.dart";

class FusedLocationProvider {
  final _instance = FusedLocationPlatformInterface.instance;

  Stream<FusedLocation> get dataStream {
    return _instance.dataStream;
  }

  Future<void> startLocationUpdates({
    required FusedLocationProviderOptions options,
  }) {
    return _instance.startLocationUpdates(options: options);
  }

  Future<void> stopLocationUpdates() {
    return _instance.stopLocationUpdates();
  }
}
