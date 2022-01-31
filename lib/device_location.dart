import 'package:geolocator/geolocator.dart';

class DeviceLocation {
  /* Should be able to access the device location using these three functions. 
  Need to call getDeviceLocation to see if we need permissions, get them if 
  needed, and return the Lat Long.*/
  void getDeviceLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      getLocation();
    } else {
      requestLocationPermission();
    }
  }

  requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      getLocation();
    } else {
      requestLocationPermission();
    }
  }

  getLocation() async {
    Position location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 1));
    return (location);
  }
}
