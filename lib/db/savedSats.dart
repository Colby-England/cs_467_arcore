import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import '../models/user_sats.dart';
import '../src/satellite.dart';

class DbHelper {
  Database? _database;
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();
  final tableName = 'savedSats';

  DbHelper._init();

  Future<Database> get database async {
    //deleteDatabase('savedSats.db');
    if (_database != null) return _database!;

    _database = await _initDB('$tableName.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    final open = await openDatabase(path, version: 1, onCreate: _createDB);

    return open;
  }

  Future _createDB(Database db, int version) async {
    var check =
        await db.execute('CREATE TABLE IF NOT EXISTS $tableName (satId TEXT)');
  }

  create(UserSat sat) async {
    final db = await instance.database;

    final id = await db.insert(tableName, sat.toJson());
  }

/*   Future<UserSat> create(UserSat sat) async {
    final db = await instance.database;

    final id = await db.insert(tableName, sat.toJson());
    return sat.copy(satId: sat.satId);
  } */

  Future<UserSat> readSat(int id) async {
    // input the NORAD ID of the desired sat
    final db = await instance.database;

    final maps = await db.query(tableName,
        columns: ['satId'], where: 'satId = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return UserSat.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<UserSat>> readAllSats() async {
    final db = await instance.database;

    final result = await db.query(tableName);
    final listOut = result.map((json) => UserSat.fromJson(json)).toList();

    return listOut;
  }

  Future<int> update(UserSat sat) async {
    final db = await instance.database;

    return db.update(tableName, sat.toJson(),
        where: 'satId = ?', whereArgs: [sat.satId]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(tableName, where: 'satId = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
