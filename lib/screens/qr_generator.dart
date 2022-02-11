import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:QR_Scanner/constants.dart';
import 'package:QR_Scanner/utilities/DataCacheManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:QR_Scanner/controllers/controllers.dart';
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
  ColorController c = Get.find();
  final BannerAd bannerAd = BannerAd(
    adUnitId: bannerAdId,
    size: AdSize.mediumRectangle,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bannerAd.load();

  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<GeneratorController>();
    return Scaffold(
      appBar: CustomNavigation(
        title: Text(
          DataCacheManager.language.create,
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: key,
              child: Container(
                color: Colors.white,
                child: Obx(() {
                  return QrImage(
                      size: controller.textData.value.isEmpty ? 0 : 200,
                      data: controller.textData.value);
                }),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: textcontroller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                  labelText: DataCacheManager.language.enterValue,
                ),
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(DataCacheManager.language.createQR)),
              ),
              style: ElevatedButton.styleFrom(
                  primary:  c.primaryColor.value,
                  fixedSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () async {
                setState(() {
                  textdata = textcontroller.text;
                  controller.textData.value = textcontroller.text;
                  FocusScope.of(context).unfocus();
                });
              },
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              child: Text(DataCacheManager.language.share),
              style: ElevatedButton.styleFrom(
                  primary:  c.primaryColor.value,
                  fixedSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),

              onPressed: controller.textData.value.isEmpty ? null : openShare,
            ),
            SizedBox(height: 30,),
            Container(height: 250, color: Colors.transparent,child:
            AdWidget(ad:  bannerAd )

              ,)

          ],
        ),
      ),
    );
  }

  openShare() async {
    {
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
    text: "${DataCacheManager.language.shareSubject1},\n ${DataCacheManager.language.shareSubject2}: ${textcontroller.text}",
    );
    } catch (e) {
    print(e.toString());
    }
  }
  }
}

