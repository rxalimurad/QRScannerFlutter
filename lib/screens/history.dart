import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:QR_Scanner/Screens/resultScreen.dart';
import 'package:QR_Scanner/controllers/controllers.dart';
import 'package:QR_Scanner/utilities/DBHandler.dart';
import 'package:QR_Scanner/widgets/CustomNavigation.dart';

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
    return Scaffold(
      appBar: CustomNavigaton(
          title:  Text(
            "History",
            style: TextStyle(color: Colors.white, fontSize: 30),
          )),

      body: Obx(() {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 0),
              child:  Material(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                elevation: 10.0,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                  onPressed: (){
                var dataToShow = c.qrHistoryList.value[index].data;
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ResultScreen(dataToShow)),
                );
                },
                  onLongPress: (){
                    var srNo = c.qrHistoryList.value[index].sr;
                    displayModalBottomSheet(context,srNo);

                  },
                  child: Center(
                      child: Row(
                        children: [
                          QrImage(
                            size: 70,//size of the QrImage widget.
                            // ignore: invalid_use_of_protected_member
                            data: c.qrHistoryList.value[index].data,//textdata used to create QR code
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start ,
                              children: [
                                // ignore: invalid_use_of_protected_member
                                Text(c.qrHistoryList.value[index].data, textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black), maxLines: 2,
                                  overflow: TextOverflow.ellipsis,),
                                SizedBox(height: 10,),
                                // ignore: invalid_use_of_protected_member
                                Text(c.qrHistoryList.value[index].time,
                                    style: TextStyle(color: Colors.grey)),

                              ],),
                          ),
                          SizedBox(height: 100,)

                        ]    ),
                      ),
                ),
              ),
            );
          },
            // ignore: invalid_use_of_protected_member
          itemCount: c.qrHistoryList.value.length
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.find<ColorController>().primaryColor.value,
        onPressed: () async {
        await DBHandler.syncData(context);
      },child: Icon(Icons.sync),),
    );
  }

  void displayModalBottomSheet(context, int sr) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.delete),
                    title: new Text('Delete'),
                    onTap: () async {
                        await DBHandler.deleteData(sr);
                        HistoryController c = Get.find();
                        c.qrHistoryList.value = (await DBHandler.getData()).reversed.toList();
                        print("Entry Deleted");
                        Navigator.of(context).pop(false);

                    }),
                new ListTile(
                  leading: new Icon(Icons.cancel),
                  title: new Text('Cancel'),
                  onTap: () {
                  Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          );
        });
  }
}
class HistoryController extends GetxController {
  var qrHistoryList = <QRHistory>[].obs;
}