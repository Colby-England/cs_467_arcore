/* https://api.n2yo.com/rest/v1/satellite/above/41.702/-76.014/0/70/18/&apiKey=K72QGY-846NUF-R4GJ2Q-4U1V
{"info":
{"category":"Amateur radio","transactionscount":0,"satcount":2},
"above":[
  {"satid":14129,"satname":"OSCAR 10","intDesignator":"1983-058B","launchDate":"1983-06-16","satlat":2.8426,"satlng":-64.823,"satalt":21156.2364},
  {"satid":46839,"satname":"BY70-3","intDesignator":"2020-079N","launchDate":"2020-11-06","satlat":44.2454,"satlng":-74.7064,"satalt":458.6398}
  ]
  }
*/

import 'dart:convert';
import 'package:cs_467_arcore/satellite.dart';

class Satellites {
  /* Top level, retrieve a JSON encoded string from API-Whatsup? */
  String jsonWhatsup =
      '{"info":{"category":"Amateur radio","transactionscount":0,"satcount":2},"above":[{"satid":14129,"satname":"OSCAR 10","intDesignator":"1983-058B","launchDate":"1983-06-16","satlat":2.8426,"satlng":-64.823,"satalt":21156.2364},{"satid":46839,"satname":"BY70-3","intDesignator":"2020-079N","launchDate":"2020-11-06","satlat":44.2454,"satlng":-74.7064,"satalt":458.6398}]}';
  List<Satellite> satellites = [];
  final Satellite? nullSat = null;

  Satellites() {
    parseJson(jsonWhatsup);
  }

  parseJson(String jsonSat) {
    mapSatellite(jsonDecode(jsonWhatsup));
  }

  mapSatellite(Map<String, dynamic> jsonSat) {
    for (var sat in jsonSat['above']) {
      satellites.add(Satellite.fromJson(sat));
    }
  }

  Satellite? getSatellitebyId(int satid) {
    /*
    returns nullSatellite if not found in list.
    */
    for (final Satellite sat in satellites) {
      if (satid == sat.satid) {
        return sat;
      }
    }
    return nullSat;
  }
}