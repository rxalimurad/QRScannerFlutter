import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:QR_Scanner/controllers/controllers.dart';
import 'package:QR_Scanner/screens/UserDefaults.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DBHandler.dart';

class Util {
  static setControllerFromCache(){
    GoogleSignInController controller = Get.find();
    ColorController colorController = Get.find();
    controller.email.value = UserDefaults.email;
    controller.googleName = UserDefaults.userName;
    controller.picUrl.value = UserDefaults.picURL;
    if (UserDefaults.primaryColor.isNotEmpty)
      colorController.primaryColor.value = Util.fromHex(UserDefaults.primaryColor);
    controller.lastSyncAt.value = UserDefaults.lastSyncAt;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.wave;
  }
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String getDateNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMM dd, yyyy hh:mm a');
    final String formatted = formatter.format(now);
    return formatted;
  }

  static DateTime getDateObj(String time) {
    return DateFormat('MMM dd, yyyy hh:mm a').parse(time);
  }

  static Future launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
    return;
  }

  static Future<Uint8List> getImage(context) async {
    RenderRepaintBoundary boundary =
        context.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  static List<ActionObj> getActionsData(String resultStr) {
    List<ActionObj> actions = [];
    actions.add(
      ActionObj("Copy to Clipboard", ActionsEnum.copy, Icons.copy),
    );

    if (GetUtils.isURL(resultStr)) {
      actions.add(
        ActionObj("Open URL", ActionsEnum.openUrl, Icons.link),
      );
    }
    if (GetUtils.isEmail(resultStr)) {
      actions.add(
        ActionObj("Send Email", ActionsEnum.email, Icons.email),
      );
    }
    if (GetUtils.isPhoneNumber(resultStr)) {
      actions.add(
        ActionObj("Call", ActionsEnum.call, Icons.call),
      );
    }
    if (GetUtils.isPhoneNumber(resultStr)) {
      actions.add(
        ActionObj("Send Message", ActionsEnum.sms, Icons.sms),
      );
    }
    actions.add(
      ActionObj("Share", ActionsEnum.share, Icons.share),
    );

    return actions;
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }
  static void syncDataIfNeeded() {
    var lastSyncDate = UserDefaults.lastSyncAt;
    if (lastSyncDate.isNotEmpty) {
      var diff = Util.getDateObj(lastSyncDate).difference(DateTime.now());
      if (((diff.inHours >  24)) || (diff.inHours < -24 )) {
        DBHandler.syncData();
      }
    }
  }



}

class ActionObj {
  String name;
  ActionsEnum action;
  IconData icon;

  ActionObj(this.name, this.action, this.icon);
}

enum ActionsEnum { email, sms, call, copy, openUrl, whatsapp, share }
