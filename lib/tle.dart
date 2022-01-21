import 'package:sgp4_sdp4/sgp4_sdp4.dart';

// Dragon CRS-24 Noradid 50318
// dev key K72QGY-846NUF-R4GJ2Q-4U1V
//https://api.n2yo.com/rest/v1/satellite/tle/50318&apiKey=K72QGY-846NUF-R4GJ2Q-4U1V
/* TLE : 
{"info":
{"satid":50318
,"satname":"DRAGON CRS-24","transactionscount":0}
,"tle":"1 50318U 21127A   22020.41281547  .00003879  00000-0  77034-4 0  9990
\r\n    2 50318  51.6459 348.3929 0006588  42.4271 100.8849 15.49574825322269"}
Space Station :  25544
{"info":{"satid":25544,"satname":"SPACE STATION","transactionscount":1},
"tle":
"1 25544U 98067A   22021.57497024  .00045667  00000-0  81365-3 0  9999
\r\n
2 25544  51.6437 342.6425 0007051  40.5873 110.0531 15.49622456322444
"}
My lat/long: 
46.59271
-112.03611
Mag: 12 7E
*/
main() {
  /// TLE Example. Getting from https://www.celestrak.com/NORAD/elements/
  const String name = "Space Station";
  const String line1 =
      "1 25544U 98067A   22021.57497024  .00045667  00000-0  81365-3 0  9998";
  const String line2 =
      "2 25544  51.6437 342.6425 0007051  40.5873 110.0531 15.49622456322444";

  final Site myLocation = //Site.fromLatLngAlt(46.59271, -112.03611, 59 / 1000);
      Site.fromLatLngAlt(23.1359405517578, -82.3583297729492, 59 / 1000.0);

  /// Get the current date and time
  final dateTime = DateTime.now();

  /// Parse the TLE
  final TLE tleSGP4 = new TLE(name, line1, line2);

  ///Create a orbit object and print if is
  ///SGP4, for "near-Earth" objects, or SDP4 for "deep space" objects.
  final Orbit orbit = new Orbit(tleSGP4);
  print("is SGP4: ${orbit.period() < 255 * 60}\n");

  /// get the Keplerian elements
  print("Keplerian elements and values:");
  print("Argument of Perigee: ${rad2deg(orbit.argPerigee())}");
  print("Eccentricity: ${orbit.eccentricity()}");
  print("Inclination:  ${rad2deg(orbit.inclination())}");
  print("RAAN:         ${rad2deg(orbit.raan())}");
  print("Mean Motion:  ${orbit.meanMotion()}");
  print("Mean Anonmoly:  ${rad2deg(orbit.meanAnomaly())}");

  /// get the utc time in Julian Day
  ///  + 4/24 need it, diferent time zone (Cuba -4 hrs )
  final double utcTime = Julian.fromFullDate(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute)
          .getDate() +
      4 / 24.0;
  print("Dates ----");
  print(utcTime);
  print(MIN_PER_DAY);
  print(orbit.epoch().getDate());

  final Eci eciPos =
      orbit.getPosition((utcTime - orbit.epoch().getDate()) * MIN_PER_DAY);

  ///Get the current lat, lng of the satellite
  final CoordGeo coord = eciPos.toGeo();
  if (coord.lon > PI) coord.lon -= TWOPI;

  CoordTopo topo = myLocation.getLookAngle(eciPos);
  print("\n\n");
  print("lat: ${rad2deg(coord.lat)}");
  print("lng: ${rad2deg(coord.lon)}");
  print("Azimut: ${rad2deg(topo.az)}");
  print("Elevation: ${rad2deg(topo.el)}");
  print("Height: ${coord.alt}");
  print("Range: ${topo.range}");
  print("Period: ${(orbit.period() / 60.0).round()} min");
}
