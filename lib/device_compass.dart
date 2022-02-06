import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

Future<Object> determineHeading() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  final CompassEvent tmp = await FlutterCompass.events!.first;
  double? heading = tmp.heading;
  if (heading! < 0) {
    heading = (360 - heading.abs());
  }
  double? ccHeading = (heading - 360).abs();
  return ccHeading;
}
