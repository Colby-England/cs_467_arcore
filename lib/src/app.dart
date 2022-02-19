import 'satellites.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'satellite.dart';

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
    final Satellites satsAbove = Satellites();
    await satsAbove.getApiWhatsup(); // Call the Whatsup API

    for (final Satellite sat in satsAbove.satellites) {
      await sat.getTle(sat.satid);
      sat.getPosition(
          numberOfCalcs: 10,
          durationMinutes: 1); // Calculate 10 positions in 1 minute intervals.
    }
    return satsAbove;
  }
}
