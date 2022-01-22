import 'dart:io';
import 'package:cs_467_arcore/julianday.dart';
import 'package:sgp4_sdp4/sgp4_sdp4.dart';
import 'package:json_annotation/json_annotation.dart';
part 'satellite.g.dart';

@JsonSerializable()
class Satellite {
  /* Json populated values */
  int satid;
  String satname;
  String intDesignator;
  String launchDate;
  double satlat;
  double satlng;
  double satalt;

  /* Function Populated */
  final Site myLocation = Site.fromLatLngAlt(46.59271, -112.03611, 59 / 1000);
  //Site.fromLatLngAlt(23.1359405517578, -82.3583297729492, 59 / 1000.0);
  List<String> tleData = [];

  Satellite(this.satid, this.satname, this.intDesignator, this.launchDate,
      this.satlat, this.satlng, this.satalt) {
    _getTle(satid);
  }

  factory Satellite.fromJson(Map<String, dynamic> json) =>
      _$SatelliteFromJson(json);

  //Map<String, dynamic> toJson() => _$SatellitetoJson(this);

  void _getTle(satid) {
    tleData = _apiReturn(satid);
  }

  List<String> _apiReturn(satid) {
    //Mimic API call.
    return [
      "1 25544U 98067A   22021.57497024  .00045667  00000-0  81365-3 0  9998",
      "2 25544  51.6437 342.6425 0007051  40.5873 110.0531 15.49622456322444"
    ];
  }

  List<double> getCurrentPosition() {
    /// Parse the TLE
    final TLE tleSGP4 = TLE(satname, tleData[0], tleData[1]);

    ///Create a orbit object and print if is
    ///SGP4, for "near-Earth" objects, or SDP4 for "deep space" objects.
    ///All will be near earth  SGP4
    final Orbit orbit = Orbit(tleSGP4);

    /// Built a new Julian days class/function the provided one in the library
    /// was 1 day off, and only computed minute by minute.
    JulianDays jd = JulianDays();

    final double utcTime = jd.getJulian();

    final Eci eciPos =
        orbit.getPosition((utcTime - orbit.epoch().getDate()) * MIN_PER_DAY);

    final CoordGeo coord = eciPos.toGeo();
    if (coord.lon > PI) coord.lon -= TWOPI;

    CoordTopo topo = myLocation.getLookAngle(eciPos);
    /*
    print("\n\n");
    print("lat: ${rad2deg(coord.lat)}");
    print("lng: ${rad2deg(coord.lon)}");
    print("Azimut: ${rad2deg(topo.az)}");
    print("Elevation: ${rad2deg(topo.el)}");
    print("Height: ${coord.alt}");
    print("Range: ${topo.range}");
    print("Period: ${(orbit.period() / 60.0).round()} min");
    */
    satlat = rad2deg(coord.lat);
    satlng = rad2deg(coord.lon);
    return [satlat, satlng];
  }
}
