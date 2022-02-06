import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

void determineHeading() => runApp(const CompassApp());

class CompassApp extends StatefulWidget {
  const CompassApp({
    Key? key,
  }) : super(key: key);

  @override
  _CompassAppState createState() => _CompassAppState();
}

class _CompassAppState extends State<CompassApp> {
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();

    _fetchPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasPermissions) {
      return getHeading();
    } else {
      return _buildPermissionSheet();
    }
  }

  getHeading() async {
    final CompassEvent tmp = await FlutterCompass.events!.first;
    double? heading = tmp.heading;
    if (heading! < 0) {
      heading = (360 - heading.abs());
    }
    double? ccHeading = (heading - 360).abs();
    return ccHeading;
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Compass Permission Required'),
          ElevatedButton(
            child: const Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }
}
