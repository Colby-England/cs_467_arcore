//import 'package:cs_467_arcore/satellites.dart';
import 'package:flutter/material.dart';
import 'app.dart';

class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}

void main() {
  runApp(const SatTrack());
}

//final Satellites above = Satellites();
//final Satellite iss = Satellite(25544);
//List<double> issPosition = iss.getCurrentPosition(25544);

//print(issPosition[0].toString() + "-" + issPosition[1].toString());
//above.parseJson(above.jsonWhatsup);

//print(above.satellites[0].getCurrentPosition());
