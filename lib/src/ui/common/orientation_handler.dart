import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// orientation_handler.dart
import 'package:flutter/material.dart';

class OrientationWidget extends StatefulWidget {
  final Widget child;
  final List<DeviceOrientation> orientations;
  final RouteObserver<PageRoute> routeObserver;

  const OrientationWidget({
    super.key,
    required this.child,
    required this.orientations,
    required this.routeObserver,
  });

  @override
  State<OrientationWidget> createState() => _OrientationWidgetState();
}

class _OrientationWidgetState extends State<OrientationWidget> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      widget.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  void didPush() => _setOrientation();
  @override
  void didPopNext() => _setOrientation();
  @override
  void didPushNext() => _resetOrientation();
  @override
  void didPop() => _resetOrientation();

  void _setOrientation() {
    SystemChrome.setPreferredOrientations(widget.orientations);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}