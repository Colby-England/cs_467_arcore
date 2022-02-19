import 'package:flutter/material.dart';
// import '../satellites.dart';
import 'package:cs_467_arcore/src/satellites.dart';
import 'tracking_map.dart';
import 'hello_world.dart';


class HomeScreen extends StatelessWidget {
  Satellites satData;
  HomeScreen(this.satData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sat Track')
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TrackingMap(satData)));
            },
            title: const Text('Tracking Map'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const DebugOptionsWidget()));
            },
            title: Text('AR Hello World'),
          ),
          SingleChildScrollView(
          child:Padding(
            padding: EdgeInsets.all(10),
            child:Column(
                  children: getSatData(satData),
          )
          )
          )
        ]
      )
    );
  }
}

List<Widget> getSatData(Satellites satData){
  List<Widget> rlist = [];
  for(var sat in satData.satellites){
    rlist.add(Column(children: [
      Row(
          children:[
          Text("SatName: ${sat.satname}"),
          ],
      ),
      Column(children: [          
        Text("Latitude: ${sat.satlat.toString()}"),
        Text("Longitude: ${sat.satlat.toString()}"),
        Text("Height/Altitude: ${sat.satalt.toString()}")],
        ),
        Padding(
          padding: EdgeInsets.all(10),
        )]
      )
      );
  }
  return rlist;
}