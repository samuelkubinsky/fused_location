import "package:flutter/material.dart";

import "package:fused_location_example/screen/location_screen.dart";

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      restorationScopeId: "root",
      title: "fused_location_example",
      home: LocationScreen(),
    );
  }
}
