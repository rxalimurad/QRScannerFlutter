import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scan_generator/Screens/resultScreen.dart';
import 'package:qr_scan_generator/Utilities/DataCacheManager.dart';
import 'package:qr_scan_generator/controllers/controllers.dart';
import 'package:r_scan/r_scan.dart';


class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ColorController colorController = Get.find();

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
   return Stack(
        children: [
          _buildQrView(context),
          Positioned(
            child: FloatingActionButton(
              backgroundColor: colorController.primaryColor.value,
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
                child: (Icon(Icons.flash_on, size: 30))),
            right: 20,
            bottom: 10,
          ),
          Positioned(
            child: FloatingActionButton(
                backgroundColor: colorController.primaryColor.value,
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
                backgroundColor: colorController.primaryColor.value,
                onPressed: () async {

                  var _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  final result = await RScan.scanImagePath(image!.path);
                  if (result.message == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ResultScreen("")),
                    );
                    DataCacheManager().showingPopup = true;

                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ResultScreen("${result.message}")),
                    );
                    DataCacheManager().showingPopup = true;
                  }



                },
                child: (Icon(Icons.photo, size: 30))),
            left: (MediaQuery.of(context).size.width / 2) - 15.0,
            bottom: 20,
          ),
        ],
      );
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
          borderColor: colorController.primaryColor.value,
          borderRadius: 40,
          borderLength: 40,
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ResultScreen("${scanData.code}")),
        );
        DataCacheManager().showingPopup = true;

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