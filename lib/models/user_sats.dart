import 'package:flutter/material.dart';

class UserSat {
  late int satid;
  late String satname;
  late String satlat;
  late String satlng;

  int get satId => satid;
  String get satName => satname;
  String get satLat => satlat;
  String get satLng => satlng;

  Map<String, Object> toJson() => {'satId': satid.toString()};

  UserSat copy({int? satId}) {
    final userSat = UserSat();
    userSat.satid = satId ?? this.satId;
    return userSat;
  }

  static UserSat fromJson(json) {
    final userSat = UserSat();
    userSat.satid = int.parse(json['satId']) as int;
    return userSat;
  }
}

/*               final satData = await getPosition(satid);
              final satInfo = satData['info'];
              final satPosition = satData['positions'][0];
              final userSat = Satellite(satid, satInfo['satname'],
                  satPosition['satlatitude'], satPosition['satlongitude']); */
