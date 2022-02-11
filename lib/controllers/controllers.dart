import 'package:QR_Scanner/utilities/DBHandler.dart';
import 'package:QR_Scanner/utilities/DataCacheManager.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:QR_Scanner/screens/UserDefaults.dart';
import 'package:QR_Scanner/constants.dart';

class ColorController extends GetxController {
  var primaryColor = initPrimaryColor.obs;
  var colorDialogColor = initPrimaryColor.obs;

}

class GoogleSignInController extends GetxController {
  var email = UserDefaults.email.obs;
  var googleBtnText = DataCacheManager.language.signInWithGoogle.obs;
  var googleName = "";
  var picUrl = "".obs;
  var lastSyncAt = "".obs;
}


class HistoryController extends GetxController {
  var qrHistoryList = <QRHistory>[].obs;
}

class GeneratorController extends GetxController {
  var textData = "".obs;

}