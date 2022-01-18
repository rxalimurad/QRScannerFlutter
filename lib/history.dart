import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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
                  Text(c.qrHistoryList.value[index].data),
                  Spacer(),
                  Text(c.qrHistoryList.value[index].time),
                ],
              ));
        },
        itemCount: c.qrHistoryList.value.length
      );
    });
  }
}
class HistoryController extends GetxController {
  var qrHistoryList = <QRHistory>[].obs;
}