import "package:fused_location/fused_location.dart";
import "package:fused_location/fused_location_options.dart";
import "package:fused_location/fused_location_provider.dart";

class LocationRepository {
  final _service = FusedLocationProvider();

  Stream<FusedLocation> get dataStream {
    return _service.dataStream;
  }

  Future<void> startLocationUpdates() {
    const options = FusedLocationProviderOptions(distanceFilter: 5);
    return _service.startLocationUpdates(options: options);
  }

  Future<void> stopLocationUpdates() {
    return _service.stopLocationUpdates();
  }
}
