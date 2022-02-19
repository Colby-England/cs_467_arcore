import 'satellites.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'satellite.dart';
import 'package:cs_467_arcore/src/device_location.dart';
import 'package:geolocator/geolocator.dart';


class SatTrack extends StatelessWidget {
  SatTrack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Satellites>(
      future: satData,
      builder: (context, AsyncSnapshot<Satellites> snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Sat Track',
            theme: ThemeData(primarySwatch: Colors.blueGrey),
            home: HomeScreen(snapshot.data!),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<Satellites> get satData async {

    final Position originPos = await determinePosition();

    final Satellites satsAbove = Satellites();
    await satsAbove.getApiWhatsup(); // Call the Whatsup API

    for (final Satellite sat in satsAbove.satellites) {
      await sat.getTle(sat.satid);
      sat.getPosition(
          numberOfCalcs: 20,
          durationMinutes: 1, originPos: originPos); // Calculate 10 positions in 1 minute intervals.
    }
    return satsAbove;
  }
}
