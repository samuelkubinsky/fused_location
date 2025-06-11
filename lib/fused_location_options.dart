class FusedLocationProviderOptions {
  const FusedLocationProviderOptions({
    required this.distanceFilter,
  });

  /// The minimum distance in meters the device must move horizontally
  /// before an update event is generated.
  final double distanceFilter;

  Map<String, double> toJson() {
    return {
      "distanceFilter": distanceFilter,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FusedLocationProviderOptions &&
          runtimeType == other.runtimeType &&
          distanceFilter == other.distanceFilter;

  @override
  int get hashCode => distanceFilter.hashCode;
}
