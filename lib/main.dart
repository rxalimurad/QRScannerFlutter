import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:QR_Scanner/controllers/controllers.dart';
import 'package:QR_Scanner/screens/UserDefaulfs.dart';
import 'package:QR_Scanner/screens/history.dart';
import 'package:QR_Scanner/screens/qr_generator.dart';
import 'package:QR_Scanner/screens/scanner.dart';
import 'package:QR_Scanner/screens/settings.dart';
import 'package:QR_Scanner/utilities/DataCacheManager.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

setControllerFromCache(){
  ColorController controller = Get.find();
  controller.email.value = UserDefaults.email;
  controller.googleName = UserDefaults.userName;

}
void main()async {
  Get.lazyPut(() => GeneratorController());
  Get.lazyPut(() => ColorController());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DataCacheManager.prefs = await SharedPreferences.getInstance();
  setControllerFromCache();
  runApp(const MyApp());



}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
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
            var controller = Get.find<GeneratorController>();
            controller.textData.value = "";
            FocusScope.of(context).unfocus();


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
          var controller = Get.find<GeneratorController>();
          controller.textData.value = "";
          FocusScope.of(context).unfocus();

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
