import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class Util {
 static String getDateNow() {
   final DateTime now = DateTime.now();
   final DateFormat formatter = DateFormat('MMM dd, yyyy');
   final String formatted = formatter.format(now);
   return formatted;
 }

 static Future<Uint8List> getImage(context) async {
    RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }
}