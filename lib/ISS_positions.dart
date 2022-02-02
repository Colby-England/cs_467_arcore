//import 'package:requests/requests.dart';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:developer';

void main(List<String> arguments) {
  const lat = '37.713';
  const lng = '-119.605';
  final alt = getAltitude(lat, lng);
  List<int> desiredSats = const [25544]; // just the ISS for now
  satLocation(desiredSats, lat, lng, alt);
}

dynamic getJson(String url) async {
  var apiUrl = Uri.parse(url);
  var response = await http.get(apiUrl);
  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body);
  } else {
    log('Request failed with status: ${response.statusCode}.');
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

void satLocation(List<int> allSats, obsLat, obsLng, obsAlt) async {
  String key = '8HEYM7-E8KFB7-AWGJTR-4U1C';
  for (var sat in allSats) {
    final jsonResponse =
        await getJson('https://api.n2yo.com/rest/v1/satellite//positions/'
            '$sat/$obsLat/$obsLng/$obsAlt/300/&apiKey=$key');
    final positions = jsonResponse['positions'];
    filePositions(positions);
  }
}

void filePositions(dynamic positions) {
  final filename = File('issPositions.txt');
  var sink = filename.openWrite();
  for (int i = 0; i < 300; i++) {
    if (i % 5 == 0) {
      sink.write('${positions[i]}\n');
    }
  }
  sink.close();
}
