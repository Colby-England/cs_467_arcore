import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_sats.dart';
import '../src/satellite.dart';
import '../src/satellite_dat.dart';
import '../src/app.dart';
import '../db/savedSats.dart';

class SearchSat extends StatelessWidget {
  SearchSat({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  static var namedRoute = 'searchSat';

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
              print(userSat.satId);
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
/*               var db = await openDatabase('savedSats.db', version: 1,
                  onCreate: (db, version) async {
                await db.execute(
                    'CREATE TABLE IF NOT EXISTS satellites(id INTEGER PRIMARY KEY AUTOINCREMENT, norad_id TEXT)');
              });
              await db.transaction((txn) async {
                await txn.rawInsert(
                    'INSERT INTO journal_entries(norad_id) VALUES (?)',
                    [userSat.satId]);
              });
              await db.close(); */
              print(userSat.satId);
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
}

/* to do :
- change the way user sats are loaded to account for the db
- add the ability to remove a satellite from list
*/
