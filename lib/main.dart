import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scan_generator/scanner.dart';

import 'generator.dart';
import 'history.dart';

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
              // DataCacheManager().showingPopup = false;
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
                child: QRGeneratorSharePage(),
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: c.selectedTab.value == 3,
              child: Container(
                color: getColor(),
                child: HistoryView(),
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

enum InputMode {
  camera, gallery
}
class BottomController extends GetxController {
  var selectedTab = 0.obs;
  var inputMode = InputMode.camera.obs;
}
