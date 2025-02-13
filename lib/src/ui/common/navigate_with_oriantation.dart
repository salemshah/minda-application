import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum NavigationType {
  push,
  pushReplacement,
  pushNamedAndRemoveUntil,
  popAndPushNamed,
}

Future<void> navigateWithOrientation({
  required BuildContext context,
  Widget? screen,
  required List<DeviceOrientation> orientations,
  NavigationType navigationType = NavigationType.push,
  required String routeName,
  bool Function(Route<dynamic>)? predicate,
}) async {
  // Set the desired orientation before navigation
  await SystemChrome.setPreferredOrientations(orientations);

  // Add a small delay to ensure the orientation change is applied

  // Perform the appropriate navigation
  switch (navigationType) {
    case NavigationType.push:
      if (screen == null) {
        throw ArgumentError('routeName must be provided for popAndPushNamed');
      }
      if (context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      }
      break;

    case NavigationType.pushReplacement:
      if (screen == null) {
        throw ArgumentError('routeName must be provided for popAndPushNamed');
      }
      if (context.mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      }
      break;

    case NavigationType.pushNamedAndRemoveUntil:
      if (context.mounted) {
        await Navigator.pushNamedAndRemoveUntil(
          context,
          routeName,
          predicate ?? (route) => false, // Default predicate removes all routes
        );
      }
      break;

    case NavigationType.popAndPushNamed:
      if (context.mounted) {
        await Navigator.popAndPushNamed(context, routeName);
      }
      break;
  }
  // Reset to default orientations after navigation
  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
}
