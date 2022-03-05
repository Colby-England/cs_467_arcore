import 'package:cs_467_arcore/db/savedSats.dart';
import 'package:cs_467_arcore/models/user_sats.dart';
import 'package:cs_467_arcore/src/satellite.dart';
import 'package:flutter/material.dart';
import '../src/satellites.dart';
// import '../satellites.dart';
import 'package:cs_467_arcore/src/satellites.dart';
import 'tracking_map.dart';
import 'hello_world.dart';

class HomeScreen extends StatefulWidget {
  Satellites satData;

  HomeScreen(this.satData, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Satellites sats;

  @override
  void initState() {
    super.initState();
    sats = widget.satData;
  }

  void refresh(Satellite sat) {
    setState(() {
      sats.removeSatellite(sat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sat Track')),
        body: ListView(children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TrackingMap(sats)));
            },
            title: const Text('Tracking Map'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DebugOptionsWidget()));
            },
            title: Text('AR Hello World'),
          ),
          Column(children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    color: Colors.blueGrey[100],
                    //decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SingleChildScrollView(
                        child: Column(children: getUserSats(sats, refresh))))),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    color: Colors.blueGrey[100],
                    //decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: getSatAboveData(sats),
                            )))))
          ])
        ]));
  }
}

List<Widget> getSatAboveData(Satellites satData) {
  List<Widget> rlist = [
    Text('Satellites Above Horizon', style: TextStyle(fontSize: 20))
  ];
  for (var sat in satData.satellites) {
    if (sat.isAbove) {
      rlist.add(Column(children: listSat(sat)));
    }
  }
  return rlist;
}

List<Widget> getUserSats(satData, refresh) {
  List<Widget> rlist = [Text('My Satellites', style: TextStyle(fontSize: 20))];
  for (var sat in satData.satellites) {
    if (!sat.isAbove) {
      rlist.add(listTileSat(sat, refresh));
    }
  }
  return rlist;
}

Widget listTileSat(sat, refresh) {
  return ListTile(
      title: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("SatName: ${sat.satname}"),
          GestureDetector(
            onTap: () async {
              await deleteSat(sat.satid);
              refresh(sat);
            },
            child: const Icon(Icons.highlight_remove))
        ])
      ]),
      subtitle: Column(children: [
        Text("Latitude: ${sat.satlat.toString()}",
            style: TextStyle(color: Colors.black)),
        Text("Longitude: ${sat.satlat.toString()}",
            style: TextStyle(color: Colors.black))
      ]));
}

Future<void> deleteSat(int satID) async {
  var db = await DbHelper.instance;
  await db.delete(satID);
}

List<RenderObjectWidget> listSat(sat) {
  return [
    Row(
      children: [
        Text("SatName: ${sat.satname}"),
      ],
    ),
    Column(
      children: [
        Text("Latitude: ${sat.satlat.toString()}"),
        Text("Longitude: ${sat.satlat.toString()}"),
        //Text("Height/Altitude: ${sat.satalt.toString()}")
      ],
    ),
    Padding(
      padding: EdgeInsets.all(10),
    )
  ];
}
