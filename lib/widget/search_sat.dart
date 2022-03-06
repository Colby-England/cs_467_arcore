import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_sats.dart';
import '../src/satellite.dart';
import '../src/satellite_dat.dart';
import '../src/app.dart';
import '../db/savedSats.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchSat extends StatefulWidget {
  SearchSat({Key? key}) : super(key: key);
  static var namedRoute = 'searchSat';

  @override
  State<SearchSat> createState() => _SearchSatState();
}

class _SearchSatState extends State<SearchSat> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Satellite"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10), child: formatForm(context)));
  }

  Widget formatForm(BuildContext context) {
    final userSat = UserSat();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Form(
          key: formKey,
          child: TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
                labelText: 'NORAD ID', border: OutlineInputBorder()),
            onSaved: (value) async {
              userSat.satid = int.parse(value!);
              toast('$value saved!');
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an ID';
              } else {
                return null;
              }
            },
          )),
      const SizedBox(height: 10),
      GestureDetector(
          onTap: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              String value = userSat.satId.toString();
              toast('$value saved!');
              var db = await DbHelper.instance;
              await db.create(userSat);
            }
          },
          child: const Text('Save Entry')),
      Padding(
          padding: const EdgeInsets.only(top: 30),
          child: TextButton(
              child: const Text('Continue to app'),
              onPressed: () {
                Navigator.pushNamed(context, SatTrack.namedRoute);
              }))
    ]);
  }

  Future<bool?> toast(String message) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.green[300],
        textColor: Colors.black,
        fontSize: 15.0);
  }
}
