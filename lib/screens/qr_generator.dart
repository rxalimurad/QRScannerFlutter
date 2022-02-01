import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/CustomNavigation.dart';

class QRGeneratorSharePage extends StatefulWidget {
  const QRGeneratorSharePage({Key? key}) : super(key: key);

  @override
  _QRGeneratorSharePageState createState() => _QRGeneratorSharePageState();
}

class _QRGeneratorSharePageState extends State<QRGeneratorSharePage> {
  final key = GlobalKey();
  String textdata = '';
  final textcontroller = TextEditingController();
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavigaton(
        title:  Text(
          "Create",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
            children: [
              SizedBox(height: 100,),
              RepaintBoundary(
                key: key,
                child: Container(
                  color: Colors.white,
                  child: QrImage(
                    size: 220,//size of the QrImage widget.
                    data: textdata,//textdata used to create QR code
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textcontroller,
                ),
              ),
              ElevatedButton(
                child: Text('Create QR Code'),
                onPressed: () async {
                  setState(() {
//rebuilds UI with new QR code
                    textdata = textcontroller.text;
                  });
                },
              ),
              ElevatedButton(
                child: Text('Share'),
                onPressed: () async {
                  try {
                    RenderRepaintBoundary boundary = key.currentContext!
                        .findRenderObject() as RenderRepaintBoundary;
//captures qr image
                    var image = await boundary.toImage();

                    ByteData? byteData =
                    await image.toByteData(format: ImageByteFormat.png);

                    Uint8List pngBytes = byteData!.buffer.asUint8List();
//app directory for storing images.
                    final appDir = await getApplicationDocumentsDirectory();
//current time
                    var datetime = DateTime.now();
//qr image file creation
                    file = await File('${appDir.path}/$datetime.png').create();
//appending data
                    await file?.writeAsBytes(pngBytes);
//Shares QR image
                    await Share.shareFiles(
                      [file!.path],
                      mimeTypes: ["image/png"],
                      text: "Share the QR Code",
                    );
                  } catch (e) {
                    print(e.toString());
                  }
                },
              )
            ],
          ),
      ),
    );
  }
}


