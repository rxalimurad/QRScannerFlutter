


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:qr_scan_generator/controllers/controllers.dart';
import 'package:qr_scan_generator/screens/UserDefaulfs.dart';
import 'package:qr_scan_generator/screens/history.dart';
import 'package:qr_scan_generator/utilities/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_database/firebase_database.dart';

class DBHandler {
  FirebaseDatabase database = FirebaseDatabase.instance;
  static String createQuery =
      'CREATE TABLE history(sr INTEGER PRIMARY KEY, data TEXT, time TEXT)';
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
      var sr = element["sr"] as int;
      var data = element["data"] as String;
      var time = element["time"] as String;
      qrHistoryList.add(QRHistory(sr, data, time));
    });
    db.close();
    return qrHistoryList;
  }

  static Future<void> deleteAllData() async {
    var db = await initDB();
    var count = await db.rawDelete('DELETE FROM history');
    assert(count == 1);
    print(count);
    db.close();
    await removeAllDataFromFirebase();
  }
  static Future<void> removeAllDataFromFirebase() async {
    ColorController c = Get.find();
    var email = c.email.value;
    email = email.replaceAll("@", "");
    email = email.replaceAll(".", "");
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$email/");
    ref.remove();
  }

  static Future<void> deleteData(int sr) async {
    var db = await initDB();
    var count = await db.rawDelete('DELETE FROM history WHERE sr = ?', ['$sr']);
    assert(count == 1);
    print(count);
    db.close();
    await removeDataFromFirebase("$sr");
  }

  static Future<void> addAllData(List<QRHistory> qrHistoryList) async {


      UserDefaults.count = 0;
      qrHistoryList.forEach((element) async {
        await addData(element);
      });
  }
  static Future<void> addData(QRHistory entry) async {
    UserDefaults.count = UserDefaults.count + 1;
    var db = await initDB();
    var _ = await db.rawQuery(
        "insert into history (sr, data, time) values (${UserDefaults.count}, \"${entry.data}\", \"${entry.time}\" )");
    db.close();
   await addDataInFirebase(QRHistory(UserDefaults.count, entry.data, entry.time));
  }
  static Future<void> syncData(BuildContext context) async {
    ColorController c = Get.find();
    var email = c.email.value;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please signin to sync data')),
      );
      return;
    }
    List<QRHistory> qrHistoryList = [];
    var numberOfRows = 1;
    var db = await initDB();
    var localDB = await db.query("history");
    localDB.forEach((element) {
      var data = (element["data"] as String) ;
      var time =(element["time"] as String) ;
      qrHistoryList.add(QRHistory(numberOfRows, data, time));
    });

    email = email.replaceAll("@", "");
    email = email.replaceAll(".", "");
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$email");
    var data = await ref.get();
    final cleanup = jsonDecode(jsonEncode(data.value)) as Map<String, dynamic>;
    cleanup.forEach((key, value) {
      qrHistoryList.add(QRHistory.fromJson(value));
    });

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
  int sr = 0;
  String data = "";
  String time = "";

  factory QRHistory.fromJson(Map<String, dynamic> json) {
    final sr = json['sr'] as String;
    final data = json['data'] as String;
    final time = json['date'] as String;
    return QRHistory(int.parse(sr), data, time);
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