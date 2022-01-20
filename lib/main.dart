import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:qr_scan_generator/scanner.dart';

import 'controllers.dart';
import 'custom_icons.dart';
import 'generator.dart';
import 'history.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RootView(),
    );
  }
}

class RootView extends StatefulWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  final BottomController c = Get.put(BottomController());
  int _selectedItemPosition = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    c.selectedTab.value == 1
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(children: [
        Obx(() {
          return Visibility(
            visible: c.selectedTab.value == 1,
            child: Container(
              child: Scanner(),
            ),
          );
        }),
        Obx(() {
          return Visibility(
            visible: c.selectedTab.value == 2,
            child: Container(
              child: QRGeneratorSharePage(),
            ),
          );
        }),
        Obx(() {
          return Visibility(
            visible: c.selectedTab.value == 3,
            child: Container(
              child: HistoryView(),
            ),
          );
        }),
        Obx(() {
          return Visibility(
            visible: c.selectedTab.value == 4,
            child: Container(
              child: Center(child: Text("Tab 4")),
            ),
          );
        }),
      ]),
      bottomNavigationBar: SnakeNavigationBar.color(
        // height: 80,
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(12),
        snakeViewColor: Colors.black,
        selectedItemColor: null,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() { c.selectedTab.value = index + 1; _selectedItemPosition = index;}),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera), label: "Scan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.create_new_folder_outlined), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "About"),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
    );
  }
}
