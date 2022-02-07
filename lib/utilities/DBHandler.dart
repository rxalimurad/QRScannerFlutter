


import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:QR_Scanner/controllers/controllers.dart';
import 'package:QR_Scanner/screens/UserDefaults.dart';
import 'package:QR_Scanner/screens/history.dart';
import 'package:QR_Scanner/utilities/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_database/firebase_database.dart';

class DBHandler {
  FirebaseDatabase database = FirebaseDatabase.instance;
  static String createQuery =
      'CREATE TABLE history(sr TEXT PRIMARY KEY, data TEXT, time TEXT)';
  static String getQuery = 'select * from history';

  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    var database =
        openDatabase(join(dbPath, 'qr_history.db'), onCreate: (db, version) {
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
      var sr = element["sr"] as String;
      var data = element["data"] as String;
      var time = element["time"] as String;
      qrHistoryList.add(QRHistory(sr, data, time));
    });
    db.close();
    return qrHistoryList;
  }

  static Future<void> deleteAllData({bool removeDataFromCould = true}) async {
    var db = await initDB();
    var count = await db.delete("history");
    print("$count rows deleted.");
    db.close();
    if (removeDataFromCould) {
      await removeAllDataFromFirebase();
    }
  }
  static Future<void> removeAllDataFromFirebase() async {
    ColorController c = Get.find();
    var email = c.email.value;
    email = email.replaceAll("@", "");
    email = email.replaceAll(".", "");
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$email/");
    ref.remove();
  }

  static Future<void> deleteData(String sr) async {
    var db = await initDB();
    var count = await db.rawDelete('DELETE FROM history WHERE sr = ?', ['$sr']);
    db.close();
    await removeDataFromFirebase(sr);
  }

  static Future<void> addAllData(List<QRHistory> qrHistoryList) async {
      var db = await initDB();
      var batch = db.batch();
      qrHistoryList.forEach((element) {
        var srNo = sha256.convert(utf8.encode(element.data + element.time))  ;
        batch.insert("history", {'sr': "$srNo",'data': element.data, 'time': element.time});
        addDataInFirebase(QRHistory("$srNo", element.data, element.time));
      });
      batch.commit();
      db.close();

  }
  static Future<void> addData(QRHistory entry, {bool isInitDB = true, Database? database}) async {

    Database? db;
    if (isInitDB) {
       db = await initDB();
    } else {
      db = database;
    }

    var srNo = sha256.convert(utf8.encode(entry.data + entry.time));

      var _ = await db?.rawQuery(
          "insert into history (sr, data, time) values ( \"$srNo\", \"${entry.data}\", \"${entry.time}\" )");
    if (isInitDB) {
      db?.close();
    }

  }
  static Future<void> syncData({BuildContext? context }) async {
    ColorController c = Get.find();
    var email = c.email.value;
    if (email.isEmpty && context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to sync data in settings.')),
      );
      return;
    }
    if (!await Util.isInternetAvailable()) {
      if (context != null)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect internet before syncing.')),
      );
      return;
    }



    EasyLoading.show(status: "Syncing Data...", maskType: EasyLoadingMaskType.black);

    Map<String, QRHistory> qrHistoryMap = {};
    var db = await initDB();
    var localDB = await db.query("history");
    localDB.forEach((element) {
      var data = (element["data"] as String) ;
      var time =(element["time"] as String) ;
      var sr =(element["sr"] as String) ;
      qrHistoryMap[sr] = QRHistory(sr, data, time);

    });

    email = email.replaceAll("@", "");
    email = email.replaceAll(".", "");
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$email");
    var data = await ref.get();
    final cleanup = jsonDecode(jsonEncode(data.value));
    if (cleanup is Map<String, dynamic>) {
      cleanup.forEach((key, value) {
        if (value != null) {
          var qrResp = QRHistory.fromJson(value);
          qrHistoryMap[qrResp.sr] = qrResp;
        }
      });
    } else if  (cleanup is List<dynamic>) {
      cleanup.forEach((value) {
        if (value != null) {
          var qrResp = QRHistory.fromJson(value);
          qrHistoryMap[qrResp.sr] = qrResp;
        }
      });
    }

    var qrHistoryList = qrHistoryMap.values.toList();

     qrHistoryList.sort((a,b) {
      return (Util.getDateObj(a.time).compareTo(Util.getDateObj(b.time)));
    });

     qrHistoryList.forEach((element) {
       print(element.time);
     });
    await deleteAllData();
    await addAllData(qrHistoryList);
    HistoryController historyController = Get.find();
    historyController.qrHistoryList.value = qrHistoryList;
    EasyLoading.dismiss();
    UserDefaults.lastSyncAt = Util.getDateNow();
    Get.find<ColorController>().lastSyncAt.value = UserDefaults.lastSyncAt;
  }



  static Future<void> removeDataFromFirebase(String sr) async {
    ColorController c = Get.find();
    var email = c.email.value;
    if (email.isEmpty) {
      return;
    }

    email = email.replaceAll("@", "");
    email = email.replaceAll(".", "");
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$email/$sr");
    ref.remove();
  }

  static Future<void>  addDataInFirebase(QRHistory entry) async {
    ColorController c = Get.find();
    var email = c.email.value;
    if (email.isEmpty) {
      return;
    }
    email = email.replaceAll("@", "");
    email = email.replaceAll(".", "");
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$email/${entry.sr}");
      await ref.set({
      "sr": "${entry.sr}",
      "data": "${entry.data}",
      "date": "${entry.time}",
     });
  }







}

class QRHistory {
  String sr = "";
  String data = "";
  String time = "";

  factory QRHistory.fromJson(Map<String, dynamic> json) {
    final sr = json['sr'] as String;
    final data = json['data'] as String;
    final time = json['date'] as String;
    return QRHistory(sr, data, time);
  }

  Map<String, dynamic> toMap() {
    return {
      'sr': sr,
      'data': data,
      'time': time,
    };
  }

  QRHistory(this.sr, this.data, this.time);
}
class FirebaseRTDB {
  List<Map<int, dynamic>>? list;
}