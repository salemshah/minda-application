import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable widget that forces a specific orientation for its child.
/// You can optionally prevent the orientation reset on dispose.
class OrientationWrapper extends StatefulWidget {
  /// The orientations to set while this widget is visible.
  final List<DeviceOrientation> orientations;

  /// Whether to reset the orientation when the widget is disposed.
  final bool resetOnDispose;

  /// The child widget to display.
  final Widget child;

  const OrientationWrapper({
    super.key,
    required this.orientations,
    required this.child,
    this.resetOnDispose = true,
  });

  @override
  State<OrientationWrapper> createState() => _OrientationWrapperState();
}

class _OrientationWrapperState extends State<OrientationWrapper> {
  @override
  void initState() {
    super.initState();
    // Force the specified orientations.
    SystemChrome.setPreferredOrientations(widget.orientations);
  }

  @override
  void dispose() {
    if (widget.resetOnDispose) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
