import 'package:flutter/material.dart';
import 'screens/home.dart';

class SatTrack extends StatelessWidget {
  const SatTrack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sat Track',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home:  const HomeScreen(),
    );
  }
}