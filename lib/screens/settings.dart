import 'package:QR_Scanner/utilities/DataCacheManager.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:QR_Scanner/controllers/controllers.dart';
import 'package:QR_Scanner/screens/UserDefaults.dart';
import 'package:QR_Scanner/utilities/DBHandler.dart';
import 'package:QR_Scanner/utilities/util.dart';
import 'package:QR_Scanner/widgets/CustomNavigation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../constants.dart';

class Settings extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  var screenPickerColor = Colors.yellow.shade50;
  GoogleSignInController controller = Get.find();
  ColorController colorController = Get.find();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      "https://www.googleapis.com/auth/userinfo.profile"
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
        appBar: CustomNavigation(
          isSettingScreen: true,
          title: Text(
            DataCacheManager.language.settings,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          color: colorController.primaryColor.value,
                        ),
                        height: 70,
                        child: Center(child: Text(DataCacheManager.language.selectPrimaryColor, style: TextStyle(color: Colors.white),)),
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
                              DataCacheManager.language.vibration,
                              style: TextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Obx(() {
                              return ToggleSwitch(
                                minWidth: 50.0,
                                initialLabelIndex: UserDefaults.isVibrationON ? 0 : 1,
                                cornerRadius: 20.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                labels: [DataCacheManager.language.on, DataCacheManager.language.off],
                                activeBgColors: [
                                  [colorController.primaryColor.value],
                                  [colorController.primaryColor.value]
                                ],
                                onToggle: (index) {
                                  UserDefaults.isVibrationON = (index == 0);
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
                              DataCacheManager.language.sound,
                              style: TextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Obx(() {
                              return ToggleSwitch(
                                minWidth: 50.0,
                                initialLabelIndex: UserDefaults.isSoundON  ? 0 : 1,
                                cornerRadius: 20.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                labels: [DataCacheManager.language.on, DataCacheManager.language.off],
                                activeBgColors: [
                                  [colorController.primaryColor.value],
                                  [colorController.primaryColor.value]
                                ],
                                onToggle: (index) async {
                                  UserDefaults.isSoundON = (index == 0);


                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: enableCloudBackup,
                  child: InkWell(
                    onTap: () {
                      _handleSignIn();
                    },
                    child: Center(
                      child: Ink(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF397AF3),),
                        child: Padding(
                          padding: EdgeInsets.all(12),
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
                                  (controller.email.value.isEmpty) ? controller.googleBtnText.value : DataCacheManager.language.logout + " (${controller.googleName})",
                                  style: TextStyle(color: Colors.white),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
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
                              DataCacheManager.language.about,
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
                                  child: FutureBuilder(
                                    future: PackageInfo.fromPlatform(),
                                    builder: (w,e){

                                      return Text(
                                        "${DataCacheManager.language.applicationVerison} ${(e.data as PackageInfo).version}\n${DataCacheManager.language.buildNo} ${(e.data as PackageInfo).buildNumber}\n${DataCacheManager.language.releaseDate} $releaseDate",
                                        style: TextStyle(color: Colors.black),
                                      );
                                    },
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
          ),
        ));
  }

  buildColorPicker(BuildContext context) {
    colorController.colorDialogColor.value = colorController.primaryColor.value;
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
                colorController.colorDialogColor.value = color;
              },
              width: 44,
              height: 44,
              enableShadesSelection: false,
              borderRadius: 22,
              heading: Text(
                DataCacheManager.language.selectColor,
                style: Theme.of(context).textTheme.headline5,
              ),

            ),
            Obx(() {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: colorController.colorDialogColor.value,
                      fixedSize: const Size(280, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    ColorController controller = Get.find();
                    controller.primaryColor.value = screenPickerColor;
                    UserDefaults.primaryColor = screenPickerColor.hex;
                    Navigator.of(context).pop(false);
                  },
                  child: Text(DataCacheManager.language.apply));
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: colorController.colorDialogColor.value,
                      fixedSize: const Size(280, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(DataCacheManager.language.cancel));
            }),
          ],
        ),
      ),
    );
  }

  signIn() async {
    try {
      var info = await _googleSignIn.signIn().onError((error, stackTrace) {
        return;
      } );
      if (info != null) {
        controller.email.value = info.email;
        controller.googleName = info.displayName ?? "";
        controller.googleBtnText.value =
            "${DataCacheManager.language.logout}" + " (${controller.googleName})";
        UserDefaults.email = controller.email.value;
        UserDefaults.userName = controller.googleName;
        controller.picUrl.value = info.photoUrl ?? "";
        UserDefaults.picURL = controller.picUrl.value;
        await DBHandler.syncData(context: context);

      }
    } catch (error) {
      print(error);
    }
  }
  logout() async {
    try {
      await DBHandler.syncData(context: context);
      await _googleSignIn.signOut();
      controller.email.value = "";
      controller.googleBtnText.value = DataCacheManager.language.signInWithGoogle;
      UserDefaults.email = "";
      UserDefaults.userName = "";
      controller.picUrl.value = "";
      controller.lastSyncAt.value = "";
      UserDefaults.lastSyncAt = "";
      DBHandler.deleteAllData(removeDataFromCould: false);
    } catch (error) {
      print(error);
    }
  }
  Future<void> _handleSignIn() async {
    if (!await Util.isInternetAvailable()) {

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(DataCacheManager.language.internetWarning)),
        );
      return;
    } else {
      if (controller.email.value.isEmpty) {
        EasyLoading.show(status: DataCacheManager.language.signingIn, maskType: EasyLoadingMaskType.black);
        await signIn();
        EasyLoading.dismiss();
      } else {
        EasyLoading.show(status: DataCacheManager.language.loggingOut, maskType: EasyLoadingMaskType.black);

        await logout();
        // controller.email.value = "";
        EasyLoading.dismiss();
      }
    }

  }
}
