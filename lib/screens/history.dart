import 'package:QR_Scanner/constants.dart';
import 'package:QR_Scanner/screens/UserDefaults.dart';
import 'package:QR_Scanner/utilities/DataCacheManager.dart';
import 'package:QR_Scanner/utilities/util.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  final BannerAd bannerAd = BannerAd(
    adUnitId: bannerAdId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  initState() {
    Get.lazyPut(() => HistoryController());
    setupDB();
    super.initState();
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
      appBar: CustomNavigation(
          title: Text(
        DataCacheManager.language.history,
        style: TextStyle(color: Colors.white, fontSize: 30),
      )),
      body: Obx(() {
        return Center(
          child: Column(children: [
            Visibility(
              visible: (UserDefaults.email.isNotEmpty &&
                  Get.find<GoogleSignInController>()
                      .lastSyncAt
                      .value
                      .isNotEmpty),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                child: Container(
                  child: DottedBorder(
                      padding: const EdgeInsets.all(15.0),
                      color: Colors.black,
                      dashPattern: [5, 3],
                      strokeWidth: 1,
                      child: Text(
                          "${DataCacheManager.language.lastSyncAt} ${Get.find<GoogleSignInController>().lastSyncAt.value}")),
                  decoration: BoxDecoration(color: Util.fromHex("#66e375")),
                ),
              ),
            ),
            Visibility(
              visible: c.qrHistoryList.value.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 0),
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          elevation: 10.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white)),
                            onPressed: () {
                              var dataToShow = c.qrHistoryList.value[index].data;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResultScreen(dataToShow)),
                              );
                            },
                            onLongPress: () {
                              var srNo = c.qrHistoryList.value[index].sr;
                              displayModalBottomSheet(context, srNo);
                            },
                            child: Center(
                              child: Row(children: [
                                if (c.qrHistoryList.value[index].data.isNotEmpty)
                                  QrImage(
                                    size: 70,
                                    //size of the QrImage widget.
                                    // ignore: invalid_use_of_protected_member
                                    data: c.qrHistoryList.value[index]
                                        .data, //textdata used to create QR code
                                  ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // ignore: invalid_use_of_protected_member
                                      Text(
                                        c.qrHistoryList.value[index].data,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // ignore: invalid_use_of_protected_member
                                      Text(c.qrHistoryList.value[index].time,
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                )
                              ]),
                            ),
                          ),
                        ),
                      );
                    },
                    // ignore: invalid_use_of_protected_member
                    itemCount: c.qrHistoryList.value.length),
              ),
            ),
            Visibility(
              visible: c.qrHistoryList.value.isEmpty,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: DottedBorder(
                  color: Colors.black,
                  dashPattern: [5, 3],
                  strokeWidth: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(DataCacheManager.language.qrNRF),
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              color: Colors.transparent,
              child: FutureBuilder(
                future: bannerAd.load(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return AdWidget(ad: bannerAd);
                },
              ),
            )
          ]),
        );
      }),
      floatingActionButton: Visibility(
        visible: enableCloudBackup,
        child: FloatingActionButton(
          tooltip: DataCacheManager.language.syncToCloud,
          backgroundColor: Get.find<ColorController>().primaryColor.value,
          onPressed: () async {
            await DBHandler.syncData(context: context);
          },
          child: Icon(Icons.sync),
        ),
      ),
    );
  }

  void displayModalBottomSheet(context, String sr) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.delete),
                    title: new Text(DataCacheManager.language.delete),
                    onTap: () async {
                      await DBHandler.deleteData(sr);
                      HistoryController c = Get.find();
                      c.qrHistoryList.value =
                          (await DBHandler.getData()).reversed.toList();
                      print(DataCacheManager.language.entryDelete);
                      Navigator.of(context).pop(false);
                    }),
                new ListTile(
                  leading: new Icon(Icons.cancel),
                  title: new Text(DataCacheManager.language.cancel),
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
