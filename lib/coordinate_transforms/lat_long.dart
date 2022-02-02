import 'dart:math';
import 'package:sgp4_sdp4/sgp4_sdp4.dart';

const myLat = 35.588723;
const myLong = -97.559319;
const double myAlt = 366;

const stillLat = 36.43;
const stillLong = -106.75;
const double stillAlt = 452.52 * 1000;

void main() {
  // List<double> ecef = (latLongECEF(myLat, myLong, myAlt));
  // List<double> ecefStill = (latLongECEF(stillLat, stillLong, stillAlt));

  // print(ecef);
  // print(ecefStill);
  // print(ecefToENU(ecef, ecefStill));
}

/// constants for gps to ECEF conversion
const double a = 6378137.0;
const double e2 = 6.6943799901377997e-3;

/// Computes the x, y, z, earth centered reference coordiantes in meters
/// given lat & long in degrees and altitude in meters.
List<double> latLongECEF(double lat, double long, double alt) {

  double radLat = deg2rad(lat);
  double radLong = deg2rad(long);

  double n = a / pow((1 - e2* pow(sin(radLat), 2)), 0.5);
  double ecefX = (n + alt) * cos(radLat) * cos(radLong);
  double ecefY = (n + alt) * cos(radLat) * sin(radLong);
  double ecefZ = (n*(1-e2) + alt) * sin(radLat);

  return [ecefX, ecefY, ecefZ];
}

/// Convert ECEF coordinates to ENU coordinates from a reference location
List<double> ecefToENU(List<double> src, List<double> dst) {

  final xDelta = dst[0] - src[0];
  final yDelta = dst[1] - src[1];
  final zDelta = dst[2] - src[2];

  final radLong = deg2rad(myLong);
  final radLat = deg2rad(myLat);

  final newX = (-sin(radLong) * xDelta) + (cos(radLong) * yDelta);
  final newY = (-sin(radLat)*cos(radLong) * xDelta) + (-sin(radLat)*sin(radLong) * yDelta) + (cos(radLat) * zDelta);
  final newZ = (cos(radLat)*cos(radLong) * xDelta) + (cos(radLat)*sin(radLong) * yDelta) + (sin(radLat) * zDelta);

  return [newX, newY, newZ];
} 

/// given a set of x, y, z coordinates rotate and scale them to their respective coordinates
/// on a new coordiante system.
List<double> transformCoords(List<double> original, double angle, double scale) {

  double orgX = original[0];
  double orgY = original[1];
  double orgZ = original[2];

  double newX = ((cos(angle) * orgX - sin(angle) * orgX) * scale);
  double newY = ((sin(angle) * orgY + cos(angle) * orgY) * scale);
  double newZ = orgZ * scale;

  return [newX, newY, newZ];
}
