import "dart:async";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:fused_location/fused_location.dart";
import "package:fused_location_example/repository/location_repository.dart";
import "package:permission_handler/permission_handler.dart";

part "location_state.dart";
part "location_cubit.freezed.dart";

class LocationCubit extends Cubit<LocationState> {
  final _repository = LocationRepository();
  StreamSubscription<FusedLocation>? _listener;

  LocationCubit() : super(const LocationState.initial()) {
    _listener = _repository.dataStream.listen((data) {
      emit(LocationState.success(location: data));
    });
  }

  @override
  Future<void> close() async {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  Future<void> startButtonPressed() async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isDenied) {
      emit(const LocationState.error(message: "Location permission denied"));
      return;
    }

    return _repository.startLocationUpdates();
  }

  Future<void> stopButtonPressed() async {
    await _repository.stopLocationUpdates();
    emit(const LocationState.initial());
  }
}
