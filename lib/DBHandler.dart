import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
const dbPathName = "assets/db_file/history.db";


class DBHandler {
  static var historyQuery = "select * from history";


  static  getAppMessages() async {
    await initDB();
    try {

      var db = await openDatabase("history.db");
      print("db --= $historyQuery");
      var resultAppMessages = await db.rawQuery(historyQuery);
      print(resultAppMessages);

      db.close();
      print(resultAppMessages);
    } catch (e) {
      print("$e");
    }
  }



  static  initDB() async {
    io.Directory applicationDirectory =
    await getApplicationDocumentsDirectory();
    String dbPath = path.join(applicationDirectory.path,
        "history.db");
    bool dbExists = await io.File(dbPath).exists();
    if (!dbExists) {
      // Copy from asset
      try {
        ByteData data = await rootBundle.load(path.join(dbPathName));
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        // Write and flush the bytes written
        await io.File(dbPath).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print("No local db found?");
      }
    }
  }
}
