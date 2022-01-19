import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:qr_scan_generator/util.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DBHandler.dart';
import 'DataCacheManager.dart';
import 'package:qr_scan_generator/DBHandler.dart';
import 'package:qr_scan_generator/util.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
class AlertPopup {

  static String getButtonTitle(String content) {
    if (GetUtils.isURL(content)) {
      return "Open URL";
    } else if (GetUtils.isEmail(content)) {
      return "Send Email";
    } else if (GetUtils.isPhoneNumber(content)) {
      return "Call Phone";
    } else {
      return "Copy to clipboard";
    }
  }


  static Future _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
    return;
  }

  static showAlertDialog(String title, String content, BuildContext context, Widget? img) {
    if (content.isNotEmpty) {
      DBHandler.addData(QRHistory(0, content, Util.getDateNow()));
    }

    // set up the button
    Widget okButton = TextButton(
      child: Text(getButtonTitle(content)),
      onPressed: () async {
        DataCacheManager().showingPopup = false;
        if (GetUtils.isURL(content)) {
          await _launchURL(content);
          Navigator.pop(context);
        } else if (GetUtils.isEmail(content)) {
          await _launchURL("mailto:$content");
          Navigator.pop(context);
        } else if (GetUtils.isPhoneNumber(content)) {
          await _launchURL("tel:$content");
          Navigator.pop(context);
        } else {
          Clipboard.setData(ClipboardData(text: content));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
          Navigator.pop(context);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
        if (img != null)
            img!
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        DataCacheManager().showingPopup = true;
        return alert;
      },
    );
  }
}
