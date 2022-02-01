import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_scan_generator/Screens/qr_generator.dart';
import 'package:qr_scan_generator/Screens/scanner.dart';
import 'package:qr_scan_generator/controllers/controllers.dart';
import 'package:qr_scan_generator/screens/settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'screens/history.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  Get.lazyPut(() => ColorController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const RootView(),
          );

      },
    );
  }
}

class RootView extends StatefulWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  final pageViewController = PageController();
  int _selectedItemPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: false,
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
          Settings(),

        ], onPageChanged: (index) {
          setState(() {
            _selectedItemPosition = index;
          });
        }, controller: pageViewController,),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 10.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(const Radius.circular(0.0),)
        ),
        child: SalomonBottomBar(
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() {
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
