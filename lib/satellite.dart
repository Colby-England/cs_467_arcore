import 'package:cs_467_arcore/julianday.dart';
import 'package:cs_467_arcore/satellite_dat.dart';
import 'package:sgp4_sdp4/sgp4_sdp4.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
part 'satellite.g.dart';


class locationDetail{
  int satid = 0;
  double satlat = 0.0;
  double satlng = 0.0;
  double satheight = 0.0;
  double utcTime = 0.0;
}

@JsonSerializable()
class Satellite {
  /* Json populated values */
  int satid = 0;
  String satname;
  String intDesignator;
  String launchDate;
  double satlat;
  double satlng;
  double satalt;
  double sataz = 0.0;
  double utcTime = 0.0;

  /* Function Populated */
  final Site myLocation = Site.fromLatLngAlt(46.59271, -112.03611, 59 / 1000);
  //Site.fromLatLngAlt(23.1359405517578, -82.3583297729492, 59 / 1000.0);
  List<String> tleData = [];
  final Map<int, locationDetail> calculatedPositions = Map();
  

  Satellite(this.satid, this.satname, this.intDesignator, this.launchDate,
      this.satlat, this.satlng, this.satalt) {
    // _getTle(satid); // API call to get TLE data for This satellite object.
  }

  factory Satellite.fromJson(Map<String, dynamic> json) =>
      _$SatelliteFromJson(json);

  Future <void> getTle(int satid) async{
    var apiString = await getTLE(satid);
    LineSplitter ls = LineSplitter();
    tleData = ls.convert(apiString);
  }

  void getPosition({int numberOfCalcs = 5, int durationMinutes=1}) {
    var startTime = DateTime.now();

    int i = 0;
    while (i <= numberOfCalcs){
      /// Parse the TLE
      final TLE tleSGP4 = TLE(satname, tleData[0], tleData[1]);

      ///Create a orbit object and print if is
      ///SGP4, for "near-Earth" objects, or SDP4 for "deep space" objects.
      ///All will be near earth  SGP4
      final Orbit orbit = Orbit(tleSGP4);

      utcTime = JulianDays().getJulian(startTime.add(Duration(minutes:durationMinutes)));

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
      final locationDetail newLocation = locationDetail();
      newLocation.satid = satid;
      newLocation.satlat = rad2deg(coord.lat);
      newLocation.satlng = rad2deg(coord.lon);
      newLocation.satheight = coord.alt;
      newLocation.utcTime = utcTime;
      calculatedPositions[i] = newLocation;
      durationMinutes += durationMinutes;
      i+=1;
    }
  }
}
