import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:fused_location/fused_location.dart";
import "package:fused_location_example/app.dart";
import "package:fused_location_example/screen/components/location_info_widget.dart";
import "package:fused_location_example/screen/cubit/location_cubit.dart";

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationCubit(),
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          return switch (state) {
            InitialState() => _buildInitial(context),
            ErrorState(:final message) => _buildError(context, message),
            SuccessState(:final location) => _buildSuccess(context, location),
          };
        },
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    return _buildText(context, "Press button to start location updates");
  }

  Widget _buildError(BuildContext context, String message) {
    return _buildText(context, message);
  }

  Widget _buildText(BuildContext context, String text) {
    final appBar = AppBar(
      centerTitle: true,
      title: const Text(kAppName),
    );

    final fab = FloatingActionButton(
      child: const Icon(Icons.play_arrow),
      onPressed: () {
        context.read<LocationCubit>().startButtonPressed();
      },
    );

    final body = Center(
      child: Text(text),
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: fab,
      body: body,
    );
  }

  Widget _buildSuccess(BuildContext context, FusedLocation location) {
    final appBar = AppBar(
      centerTitle: true,
      title: const Text(kAppName),
    );

    final fab = FloatingActionButton(
      child: const Icon(Icons.stop),
      onPressed: () {
        context.read<LocationCubit>().stopButtonPressed();
      },
    );

    final body = SingleChildScrollView(
      child: LocationInfoWidget(location: location),
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: fab,
      body: body,
    );
  }
}
