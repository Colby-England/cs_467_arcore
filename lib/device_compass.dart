import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class DeviceCompass {
  /*Access the getDeviceHeading() function to get the compass bearing. The
  heading will be returned type double. */
  void getDeviceHeading() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      getHeading();
    } else {
      requestLocationPermission();
    }
  }

  requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      getHeading();
    } else {
      requestLocationPermission();
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
}
