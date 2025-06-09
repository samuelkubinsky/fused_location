part of "location_cubit.dart";

@freezed
sealed class LocationState with _$LocationState {
  const factory LocationState.initial() = InitialState;
  const factory LocationState.error({required String message}) = ErrorState;
  const factory LocationState.success({required FusedLocation location}) = SuccessState;
}
