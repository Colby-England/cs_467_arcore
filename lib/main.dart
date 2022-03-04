import 'package:flutter/material.dart';
//import 'utilities.dart';
import 'widget/search_sat.dart';
import 'src/app.dart';

class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}

void main() async {
  //runApp(const SatTrack());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Satellite Tracker',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        routes: {
          SearchSat.namedRoute: (context) => SearchSat(),
          SatTrack.namedRoute: (context) => SatTrack(),
        },
        home: SearchSat());
  }
}


/*
void main() async {
// This will initialize a list of satellites and populate a list of them.
final Satellites satsAbove = Satellites();
await satsAbove.getApiWhatsup();
print(satsAbove.jsonWhatsup);
/*
IE: satsAbove will have a <List>satellites, that list contains satellite objects
class with various vars/functions.
A satellites first position is calculated from the "WhatsUP" API and populated on
this main Satellite class... Each satellite retrieved will populate itself with
the TLE data from the API as well with _getTle() and store that information in
List<String> tleData =[]
IE: satsAbove.satellite[0].satid   <--This is the first satellite in the list
and we access the "satid" for that object.  Also contained will be json populated:
  int satid = 0;
  String satname;
  String intDesignator;
  String launchDate;
  double satlat;
  double satlng;
  double satalt;
Note ** No Azimuth is contained in the initial WhatsUP response.

To populate a range of future positions the "satellite.getPosition()" must be called.
It takes 2 arguments, numberOfCales - Number of future positions to calculate and
durationMinutes - the amount of time between each new calculation.

These calculated postions are pushed into a Map<LocationDetail>, the location detail
is just a small class to expose the variable names inserted into the list.  The <key>
in the Map<> is just an increment... 1, 2, 3 4.  Ordered by time smallest to largest.
{
  1:<LocationDetail>,
  2:<LocationDetail>
}
Location Detail will contain all of the following details for each calculated position:

## Updated : _getTLE is no longer part of the instantiation as a result of the
async call.  It now has to be "awaited" in a call from the main loop.
*/

for (final Satellite sat in satsAbove.satellites){
  await sat.getTle(sat.satid);
  sat.getPosition(numberOfCalcs:10, durationMinutes: 1); // Calculate 10 positions in 1 minute intervals.
  
  for(final int key in sat.calculatedPositions.keys){
    print(
      "satid:-> " + sat.calculatedPositions[key]!.satid.toString() + " SatLat:-> " +
      sat.calculatedPositions[key]!.satlat.toString() + " SatLong:-> " +
      sat.calculatedPositions[key]!.satlng.toString()  + " SatHeight:-> " +
      sat.calculatedPositions[key]!.satheight .toString()  + " SatUtcTime:-> " +
      sat.calculatedPositions[key]!.utcTime .toString()
      );
  }
print("\n");
}
}
*/

