import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:QR_Scanner/screens/UserDefaulfs.dart';
import 'package:QR_Scanner/utilities/DataCacheManager.dart';

const googleBtnTxt = "Sign in with Google";
class ColorController extends GetxController {
  var primaryColor = Colors.red.shade900.obs;
  var colorDialogColor = Colors.red.shade900.obs;
  var email = UserDefaults.email.obs;
  var googleBtnText = googleBtnTxt.obs;
  var googleName = "";

}