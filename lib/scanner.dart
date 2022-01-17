import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scan_generator/DBHandler.dart';
import 'package:r_scan/r_scan.dart';
import 'package:url_launcher/url_launcher.dart';


import 'DataCacheManager.dart';
import 'main.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    BottomController c = Get.find();

    return Obx(() {
      return Stack(
        children: [
          if (c.inputMode.value == InputMode.camera) _buildQrView(context),
          if (c.inputMode.value == InputMode.camera) Text("S"),
          Positioned(
            child: FloatingActionButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
                child: (Icon(Icons.flash_on, size: 30))),
            right: 20,
            bottom: 20,
          ),
          Positioned(
            child: FloatingActionButton(
                onPressed: () async {
                  await controller?.flipCamera();
                  setState(() {});
                },
                child: (Icon(Icons.flip_camera_ios, size: 30))),
            left: 20,
            bottom: 20,
          ),
          Positioned(
            child: FloatingActionButton(
                onPressed: () async {

                  var _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  final result = await RScan.scanImagePath(image!.path);
                  if (result.message == null) {
                    showAlertDialog("Empty", "" );
                  } else {
                    showAlertDialog("${result.type}", result.message! );
                  }



                },
                child: (Icon(Icons.photo, size: 30))),
            left: (MediaQuery.of(context).size.width / 2) - 15.0,
            bottom: 20,
          ),
        ],
      );
    });
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 300 ||
            MediaQuery.of(context).size.height < 300)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.yellow,
          borderRadius: 60,
          borderLength: 69,
          borderWidth: 20,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  String getButtonTitle(String content) {
    if (isUrl(content)) {
      return "Open URL";
    } else if (GetUtils.isEmail(content)) {
      return "Send Email";
    } else if (GetUtils.isPhoneNumber(content)) {
      return "Call Phone";
    } else {
      return "Copy to clipboard";
    }
  }

  bool isUrl(String str) {
    var urlPattern =
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    var match = new RegExp(urlPattern, caseSensitive: false).firstMatch(str);
    print("matchmatch $match");
    if (match == null) {
      return false;
    }
    return !(match.isBlank ?? true);
  }

  Future _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
    return;
  }

  showAlertDialog(String title, String content) {
    if (content.isNotEmpty) {
      DBHandler.addData(QRHistory(0,content,"01/01/01"));
    }

    // set up the button
    Widget okButton = TextButton(
      child: Text(getButtonTitle(content)),
      onPressed: () async {
        DataCacheManager().showingPopup = false;
        if (isUrl(content)) {
          await _launchURL(content);
          Navigator.pop(navigatorKey.currentContext!);
        } else if (GetUtils.isEmail(content)) {
          await _launchURL("mailto:$content");
          Navigator.pop(navigatorKey.currentContext!);
        } else if (GetUtils.isPhoneNumber(content)) {
          await _launchURL("tel:$content");
          Navigator.pop(navigatorKey.currentContext!);
        } else {
          Clipboard.setData(ClipboardData(text: content));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copied to clipboard')),
          );
          Navigator.pop(navigatorKey.currentContext!);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
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

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!DataCacheManager().showingPopup) {
        showAlertDialog("${scanData.format}", "${scanData.code}");
        print(
            ",,..${scanData.code} ${scanData.format} ${DataCacheManager().showingPopup}");
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
