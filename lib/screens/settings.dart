import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_scan_generator/controllers/controllers.dart';
import 'package:qr_scan_generator/screens/UserDefaulfs.dart';
import 'package:qr_scan_generator/utilities/DBHandler.dart';
import 'package:qr_scan_generator/utilities/util.dart';
import 'package:qr_scan_generator/widgets/CustomNavigation.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Settings extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  var screenPickerColor = Colors.yellow.shade50;
  ColorController controller = Get.find();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  @override
  void initState() {
    super.initState();
    // if (UserDefaults.email.isNotEmpty) {
    //   signIn();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: CustomNavigaton(
          title: Row(children: [
            Text(
              "Settings",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Container(
              child: Obx(() {
                return Text(controller.email.value);
              }),
            )
          ]),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Primary Color"),
              SizedBox(
                height: 10,
              ),
              GestureDetector(onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return buildColorPicker(context);
                    });
              }, child: Obx(() {
                return Material(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    elevation: 10.0,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: controller.primaryColor.value,
                      ),
                      height: 70,
                      child: Center(child: Text("Select Primary Color")),
                    ));
              })),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  elevation: 10.0,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.vibration),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Vibration",
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(),
                          Obx(() {
                            return ToggleSwitch(
                              minWidth: 50.0,
                              initialLabelIndex: 1,
                              cornerRadius: 20.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              labels: ['ON', 'OFF'],
                              activeBgColors: [
                                [controller.primaryColor.value],
                                [controller.primaryColor.value]
                              ],
                              onToggle: (index) {
                                print('switched to: $index');
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  elevation: 10.0,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: Row(
                        children: [
                          Icon(Icons.volume_down_rounded),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Sound",
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(),
                          Obx(() {
                            return ToggleSwitch(
                              minWidth: 50.0,
                              initialLabelIndex: 1,
                              cornerRadius: 20.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              labels: ['ON', 'OFF'],
                              activeBgColors: [
                                [controller.primaryColor.value],
                                [controller.primaryColor.value]
                              ],
                              onToggle: (index) async {
                                print('switched to: $index');

                                DBHandler.addDataInFirebase(QRHistory(
                                    3, "New Data", Util.getDateNow()));
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _handleSignIn();
                },
                child: Ink(
                  color: Color(0xFF397AF3),
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          "assets/googleicon.png",
                          width: 20,
                          height: 20,
                        ),
                        // <-- Use 'Image.asset(...)' here
                        SizedBox(width: 12),
                        Obx(() {
                          return Text(
                            (controller.email.value.isEmpty) ? controller.googleBtnText.value : "Log Out" + " (${controller.googleName})",
                            style: TextStyle(color: Colors.white),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  elevation: 10.0,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "About",
                            textScaleFactor: 1.5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  "Application Version 1.0.1\nBuild No 985665\nRelease Date 23 Jan, 2020",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  buildColorPicker(BuildContext context) {
    controller.colorDialogColor.value = controller.primaryColor.value;
    return AlertDialog(
      title: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            ColorPicker(
              color: screenPickerColor,
              onColorChanged: (Color color) {
                screenPickerColor = color;
                controller.colorDialogColor.value = color;
              },
              width: 44,
              height: 44,
              borderRadius: 22,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.headline5,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Obx(() {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: controller.colorDialogColor.value,
                      fixedSize: const Size(280, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    ColorController controller = Get.find();
                    controller.primaryColor.value = screenPickerColor;
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Apply"));
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: controller.colorDialogColor.value,
                      fixedSize: const Size(280, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel"));
            }),
          ],
        ),
      ),
    );
  }

  signIn() async {
    try {
      var info = await _googleSignIn.signIn();
      controller.email.value = info?.email ?? "";
      controller.googleName = info?.displayName ?? "";
      controller.googleBtnText.value =
          "Log Out" + " (${controller.googleName})";
      UserDefaults.email = controller.email.value;
      UserDefaults.userName = controller.googleName;
    } catch (error) {
      print(error);
    }
  }
  logout() async {
    try {
      await _googleSignIn.signOut();
      controller.email.value = "";
      controller.googleBtnText.value = googleBtnTxt;
      UserDefaults.email = "";
      UserDefaults.userName = "";
    } catch (error) {
      print(error);
    }
  }
  Future<void> _handleSignIn() async {
    if (controller.email.value.isEmpty) {
      await signIn();
    } else {
     await logout();
    }
  }
}
