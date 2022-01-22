import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
 static String getDateNow() {
   final DateTime now = DateTime.now();
   final DateFormat formatter = DateFormat('MMM dd, yyyy hh:mm a');
   final String formatted = formatter.format(now);
   return formatted;
 }
 static Future launchURL(String _url) async {
   if (!await launch(_url)) throw 'Could not launch $_url';
   return;
 }

 static Future<Uint8List> getImage(context) async {
    RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  static List <ActionObj>  getActionsData(String resultStr) {
      List <ActionObj> actions = [];
      actions.add(ActionObj("Copy to Clipboard", ActionsEnum.copy, Icons.copy),);

      if (GetUtils.isURL(resultStr)) {
        actions.add(ActionObj("Open URL", ActionsEnum.copy, Icons.link),);
      }
      if (GetUtils.isEmail(resultStr)) {
        actions.add(ActionObj("Send Email", ActionsEnum.email, Icons.email),);
      }
      if (GetUtils.isPhoneNumber(resultStr)) {
        actions.add(ActionObj("Call", ActionsEnum.call, Icons.call),);
      }
      if (GetUtils.isPhoneNumber(resultStr)) {
        actions.add(ActionObj("Send Message", ActionsEnum.sms, Icons.sms),);
      }
      actions.add(ActionObj("Share", ActionsEnum.share, Icons.share),);

      return actions;

  }


}


class ActionObj {
  String name;
  ActionsEnum action;
  IconData icon;
  ActionObj(this.name, this.action, this.icon);

}

enum ActionsEnum {
  email, sms, call, copy, openUrl, whatsapp, share

}