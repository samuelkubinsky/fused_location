
import 'fused_location_platform_interface.dart';

class FusedLocation {
  Future<String?> getPlatformVersion() {
    return FusedLocationPlatform.instance.getPlatformVersion();
  }
}
