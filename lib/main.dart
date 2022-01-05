import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';


import 'DataCacheManager.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BottomController c = Get.put(BottomController());

  @override
  Widget build(BuildContext context) {
    c.selectedTab.value = 1;
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: Obx(() {
          return CurvedNavigationBar(
            backgroundColor: getColor(),
            animationDuration: Duration(milliseconds: 200),
            animationCurve: Curves.easeInCubic,
            items: <Widget>[
              Icon(Icons.scanner, size: 30),
              Icon(Icons.add, size: 30),
              Icon(Icons.history, size: 30),
              Icon(Icons.person, size: 30),
            ],
            onTap: (index) {
              c.selectedTab.value = index + 1;
            },
          );
        }),
        body: Stack(children: [
          Obx(() {
            return Visibility(
              visible: c.selectedTab.value == 1,
              child: Container(
                color: getColor(),
                child: QRViewExample(),
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: c.selectedTab.value == 2,
              child: Container(
                color: getColor(),
                child: Center(child: Text("Tab 2")),
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: c.selectedTab.value == 3,
              child: Container(
                color: getColor(),
                child: Center(child: Text("Tab 3")),
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: c.selectedTab.value == 4,
              child: Container(
                color: getColor(),
                child: Center(child: Text("Tab 4")),
              ),
            );
          }),
        ]),
      ),
    );
  }
}

getColor() {
  BottomController c = Get.find();
  var index = c.selectedTab.value;
  if (index == 1) {
    return Colors.deepOrange;
  } else if (index == 2) {
    return Colors.deepPurple;
  } else if (index == 3) {
    return Colors.cyan;
  } else {
    return Colors.green;
  }
}

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
    return Stack(
      children: [
        _buildQrView(context),
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
          borderColor: Colors.yellow,
          borderRadius: 60,
          borderLength: 69,
          borderWidth: 20,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  bool isUrl(String str) {
    var urlPattern =
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    var match = new RegExp(urlPattern, caseSensitive: false)
        .firstMatch(str);
    return !(match.isBlank ?? false);
  }
  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
  showAlertDialog(String title, String content) {
    // set up the button
    Widget okButton = TextButton(
      child: isUrl(content) ? Text("Open") : Text("Ok"),
      onPressed: () {
        DataCacheManager().showingPopup = false;
        if (isUrl(content)) {
          _launchURL(content);
        } else {
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

class BottomController extends GetxController {
  var selectedTab = 0.obs;
}
