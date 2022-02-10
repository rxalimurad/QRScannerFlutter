import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:QR_Scanner/controllers/controllers.dart';

class CustomNavigation extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final double barHeight = 40.0;
   bool isSettingScreen = false;

  CustomNavigation({Key? key, required this.title, this.isSettingScreen = false}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 50.0);

  @override
  Widget build(BuildContext context) {
    GoogleSignInController controller = Get.find();
    ColorController colorController = Get.find();


    return PreferredSize(
        child: ClipPath(
          clipper: WaveClip(),
          child: Obx(() {
            return Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    color: colorController.primaryColor.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        title,
                      ],
                    ),
                  ),
                ),

                Positioned(child:
                ClipOval(

                  child: Visibility(
                    visible: isSettingScreen,
                    child: Obx(() {
                      return  Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.contain,
                                  image: new NetworkImage(
                                      controller.picUrl.value)
                              )
                          ));



                    }),
                  ),
                ),
                  bottom: 10, right: 20, top: 10,),

              ],
            );
          }),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight + 20));
  }
}

class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    final lowPoint = size.height - 30;
    final highPoint = size.height - 60;

    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, highPoint, size.width / 2, lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, lowPoint);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}