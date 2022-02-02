import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:satellite_dat/satellite_dat.dart';

void main(List<String> arguments) async {
  dynamic tle = await getTLE();
  print(tle);
}

dynamic getTLE([String id = "25544"]) async {
  String key = '8HEYM7-E8KFB7-AWGJTR-4U1C';
  var jsonRepsonse = await getJson(
      'https://api.n2yo.com/rest/v1/satellite/tle/$id&apiKey=$key');
  return (jsonRepsonse['tle']);
}

dynamic getJson(String url) async {
  var apiUrl = Uri.parse(url);
  var response = await http.get(apiUrl);
  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
    exit(1);
  }
}

dynamic getAltitude(String lat, String lng) async {
  // citation: https://codeburst.io/quick-tip-how-to-make-http-requests-in-dart-53fc407daf31
  // for basic format of asychronous http request
  var jsonResponse = await getJson(
      'https://api.opentopodata.org/v1/ned10m?locations=$lat,$lng');
  var results = jsonResponse['results'];
  var altitude = results[0]['elevation'];
  return altitude;
}

dynamic satLocationPrediction(List<int> allSats, obsLat, obsLng, obsAlt) async {
  String key = '8HEYM7-E8KFB7-AWGJTR-4U1C';
  for (var sat in allSats) {
    final jsonResponse =
        await getJson('https://api.n2yo.com/rest/v1/satellite//positions/'
            '$sat/$obsLat/$obsLng/$obsAlt/300/&apiKey=$key');
    final positions = jsonResponse['positions'];
    return positions;
  }
}
