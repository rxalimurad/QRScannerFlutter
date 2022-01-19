import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:crop/crop.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:r_scan/r_scan.dart';


import 'DataCacheManager.dart';
import 'alert_dialog.dart';
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

                    AlertPopup.showAlertDialog("Empty", "" ,context, "");

                  } else {
                    AlertPopup.showAlertDialog("${result.type}", result.message!, context ,result.message!);
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






  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
  controller.scannedDataStream.listen((scanData) {
    if (!DataCacheManager().showingPopup) {
        AlertPopup.showAlertDialog("${scanData.format}", "${scanData.code}", context,scanData.code!);
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
