import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:qr_scan_generator/scanner.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'controllers.dart';
import 'generator.dart';
import 'history.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final pageViewController = PageController();
  int _selectedItemPosition = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: PageView(children: [
          Scanner(),
          QRGeneratorSharePage(),
          HistoryView(),
          Center(child: Text("Tab 4")),

        ], onPageChanged: (index) {
          setState(() {
            _selectedItemPosition = index;
          });
        }, controller: pageViewController,),
      ),
      bottomNavigationBar: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(const Radius.circular(0.0),)
        ),
        child: SalomonBottomBar(
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() {
          c.selectedTab.value = index + 1;
          _selectedItemPosition = index;
          pageViewController.animateToPage(index,  duration: const Duration(milliseconds: 200),
            curve: Curves.bounceIn,);
        }),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.camera),
            title: Text("Scan"),
            selectedColor: Colors.grey,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.create_new_folder_outlined),
            title: Text("Create"),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.history),
            title: Text("History"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("About"),
            selectedColor: Colors.teal,
          ),
        ],
    ),
      ),

    );
  }
}
