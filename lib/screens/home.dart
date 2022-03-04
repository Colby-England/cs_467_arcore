import 'package:flutter/material.dart';
import '../src/satellites.dart';
import 'tracking_map.dart';
import 'hello_world.dart';

class HomeScreen extends StatelessWidget {
  Satellites satData;
  HomeScreen(this.satData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sat Track')),
        body: ListView(children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TrackingMap()));
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
                        child: Column(children: getUserSats(satData))))),
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
                              children: getSatAboveData(satData),
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

List<Widget> getUserSats(satData) {
  List<Widget> rlist = [Text('My Satellites', style: TextStyle(fontSize: 20))];
  for (var sat in satData.satellites) {
    if (!sat.isAbove) {
      rlist.add(listTileSat(sat));
    }
  }
  return rlist;
}

Widget listTileSat(sat) {
  return ListTile(
      title: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("SatName: ${sat.satname}"),
          Icon(Icons.highlight_remove)
        ])
      ]),
      subtitle: Column(children: [
        Text("Latitude: ${sat.satlat.toString()}",
            style: TextStyle(color: Colors.black)),
        Text("Longitude: ${sat.satlat.toString()}",
            style: TextStyle(color: Colors.black))
      ]));
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
