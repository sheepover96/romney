import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:romney/global/constants.dart' as constants;

DBProvider DBClient;

class DBProvider {
  static DBProvider _singleton;
  Database db;

  DBProvider._internal();

  factory DBProvider() {
    if (_singleton == null) _singleton = new DBProvider._internal();
    return _singleton;
  }

  Future init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentDirectory.path, 'romney.db');

    // await deleteDatabase(dbPath);
    this.db = await openDatabase(dbPath, version: constants.VERSION,
        onCreate: (Database newDB, int version) {
      newDB.execute("PRAGMA foreign_keys = ON;");
      newDB.execute(constants.TABLE_WORDS_INIT_QUERY);
      newDB.execute(constants.TABLE_TAGS_INIT_QUERY);
      newDB.execute(constants.TABLE_WORD_TAG_INIT_QUERY);
    }, onConfigure: (Database db) async {
      await db.execute("PRAGMA foreign_keys = ON");
    });
  }

  // void insertWord(WordInfo wordInfo) async {
  //   try {
  //     await db.insert("tutorial", wordInfo.toMap(),
  //         conflictAlgorithm: ConflictAlgorithm.fail);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
