import 'package:flutter/material.dart';
import 'tracking_map.dart';
import 'hello_world.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                  .push(MaterialPageRoute(builder: (context) => const TrackingMap()));
            },
            title: const Text('Tracking Map'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const DebugOptionsWidget()));
            },
            title: const Text('AR Hello World'),
          ),
        ]
      )
    );
  }
}