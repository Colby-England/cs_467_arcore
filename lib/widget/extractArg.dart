import 'package:cs_467_arcore/models/user_sats.dart';
import 'package:flutter/material.dart';

class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({Key? key}) : super(key: key);

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final args = ModalRoute.of(context)!.settings.arguments as UserSat;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.satName),
      ),
      body: Center(
        child: Text(args.satLat),
      ),
    );
  }
}
