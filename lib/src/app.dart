import 'satellites.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'satellite.dart';
import '../models/user_sats.dart';
import 'satellite_dat.dart';
import '../db/savedSats.dart';
import 'package:cs_467_arcore/src/device_location.dart';
import 'package:geolocator/geolocator.dart';

class SatTrack extends StatelessWidget {
  static var namedRoute = 'satTrack';
  SatTrack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as UserSat;
    return FutureBuilder<Satellites>(
      future: satData,
      builder: (context, AsyncSnapshot<Satellites> snapshot) {
        if (snapshot.hasData) {
          return HomeScreen(snapshot.data!);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<Satellites> get satData async {
    final Position originPos = await determinePosition();

    final Satellites satsAbove = Satellites();
    await satsAbove.getApiWhatsup(); // Call the Whatsup API

    // get all sats from database
    List<UserSat> userSats = await DbHelper.instance.readAllSats();
    for (var sat in userSats) {
      satsAbove.addSatellite(await expandUserSat(sat));
    }

    for (final Satellite sat in satsAbove.satellites) {
      await sat.getTle(sat.satid);
      sat.getPosition(
          numberOfCalcs: 300,
          durationMinutes: 0,
          durationSeconds: 5,
          originPos:
              originPos); // Calculate 10 positions in 1 minute intervals.
    }
    return satsAbove;
  }

  Future<Satellite> expandUserSat(userSat) async {
    final satData = await getPosition(userSat.satid);
    final satInfo = satData['info'];
    final satPosition = satData['positions'][0];
    final newSat = Satellite(userSat.satid, satInfo['satname'],
        satPosition['satlatitude'], satPosition['satlongitude']);
    newSat.isAbove = false;
    return newSat;
  }
}
