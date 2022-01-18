import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    c.qrHistoryList.value = await DBHandler.getData();
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
                  Container(height: 100, width: 100, color: Colors.red,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start ,
                    children: [
                      Text(c.qrHistoryList.value[index].data, textAlign: TextAlign.left,),
                      SizedBox(height: 10,),
                      Text(c.qrHistoryList.value[index].time),

                    ],),
                      SizedBox(height: 100,)

                ]    ),
              );
        },
        itemCount: c.qrHistoryList.value.length
      );
    });
  }
}
class HistoryController extends GetxController {
  var qrHistoryList = <QRHistory>[].obs;
}