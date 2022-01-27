
import 'package:flutter/material.dart';

class TrackingMap extends StatelessWidget {
  const TrackingMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Tracking Map'),
          ),
          body: const Text('Insert Tracking Map Here')
        )
    );
  }
}