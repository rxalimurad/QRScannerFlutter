import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHandler {
  static String createQuery =
      'CREATE TABLE history(sr INTEGER PRIMARY KEY, data TEXT, time TEXT)';
  static String getQuery = 'select * from history';

  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    var database =
        openDatabase(join(dbPath, 'qr_history.db'), onCreate: (db, version) {
      print(",,..database created");
      return db.execute(
        createQuery,
      );
    }, version: 1);
    return database;
  }

  static Future<List<QRHistory>> getData() async {
    var db = await initDB();
    List<QRHistory> qrHistoryList = [];
    var resultAppMessages = await db.rawQuery(getQuery);
    resultAppMessages.forEach((element) {
      var sr = element["sr"] as int;
      var data = element["data"] as String;
      var time = element["time"] as String;
      qrHistoryList.add(QRHistory(sr, data, time));
    });
    db.close();
    return qrHistoryList;
  }
  static Future<void> deleteData(int sr) async {
    var db = await initDB();
    var count = await db.rawDelete('DELETE FROM history WHERE sr = ?', ['$sr']);
    assert(count == 1);
    print(count);
    db.close();
  }
  static Future<void> addData(QRHistory entry) async {
    var db = await initDB();
    var _ = await db.rawQuery(
        "insert into history (data, time) values (\"${entry.data}\", \"${entry.time}\" )");
    db.close();
  }
}

class QRHistory {
  int sr = 0;
  String data = "";
  String time = "";

  Map<String, dynamic> toMap() {
    return {
      'sr': sr,
      'data': data,
      'time': time,
    };
  }

  QRHistory(this.sr, this.data, this.time);
}
