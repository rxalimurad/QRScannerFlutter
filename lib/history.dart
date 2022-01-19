import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'DBHandler.dart';

class HistoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistoryViewState();
  }
}

class HistoryViewState extends State<HistoryView> {
  @override
  initState() {
    Get.lazyPut(()=>HistoryController());
    setupDB();
    super.initState() ;
  }

  Future<void> setupDB() async {
    HistoryController c = Get.find();
    c.qrHistoryList.value = (await DBHandler.getData()).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    HistoryController c = Get.find();
    // TODO: implement build
    return Obx(() {
      return ListView.builder(
        itemBuilder: (context, index) {
          return Center(
              child: Row(
                children: [
                  QrImage(
                    size: 50,//size of the QrImage widget.
                    // ignore: invalid_use_of_protected_member
                    data: c.qrHistoryList.value[index].data,//textdata used to create QR code
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start ,
                    children: [
                      // ignore: invalid_use_of_protected_member
                      Text(c.qrHistoryList.value[index].data, textAlign: TextAlign.left,),
                      SizedBox(height: 10,),
                      // ignore: invalid_use_of_protected_member
                      Text(c.qrHistoryList.value[index].time),

                    ],),
                      SizedBox(height: 100,)

                ]    ),
              );
        },
          // ignore: invalid_use_of_protected_member
        itemCount: c.qrHistoryList.value.length
      );
    });
  }
}
class HistoryController extends GetxController {
  var qrHistoryList = <QRHistory>[].obs;
}