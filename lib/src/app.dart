import 'satellites.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';

class SatTrack extends StatelessWidget {
  Satellites satData;
  SatTrack(this.satData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sat Track',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: HomeScreen(satData),
    );
  }
}
