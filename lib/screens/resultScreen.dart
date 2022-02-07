
import 'package:QR_Scanner/utilities/util.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:QR_Scanner/utilities/DBHandler.dart';
import 'package:QR_Scanner/Utilities/DataCacheManager.dart';
import 'package:QR_Scanner/widgets/CustomNavigation.dart';

class ResultScreen extends StatefulWidget {
  String qrData;
  bool isNRF = false;
  ResultScreen(this.qrData) {
    if (this.qrData.isEmpty)
    isNRF = true;

  }
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  late List <ActionObj>  data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Util.syncDataIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    data =  Util.getActionsData(widget.qrData);

    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: CustomNavigation(
            title: Row(children: [
              IconButton(onPressed: () {
                _onBackPress();
              }, icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,)),
              Text(
                "Scanner Result",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ],)),
        body: Container(
          width: double.infinity,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DottedBorder(
                color: Colors.black,
                dashPattern: [5, 3],
                strokeWidth: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SelectableText(widget.isNRF? "No QR code found." : widget.qrData),
                ),
              ),
            ),
            Visibility(
              visible: !widget.isNRF,
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.only( top: 50),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.length,

                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            var action = data[index].action;
                            switch (action) {
                              case ActionsEnum.openUrl:
                                await Util.launchURL(widget.qrData);
                                break;
                              case ActionsEnum.email:
                                await Util.launchURL("mailto:${widget.qrData}");
                                break;
                              case ActionsEnum.call:
                                await Util.launchURL("tel:${widget.qrData}");
                                break;
                              case ActionsEnum.sms:
                                await Util.launchURL("sms:${widget.qrData}");
                                break;
                              case ActionsEnum.copy:
                                Clipboard.setData(ClipboardData(text: widget.qrData));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied to clipboard')),
                                );

                                break;
                              case ActionsEnum.share:
                                await FlutterShare.share(
                                  text: widget.qrData, title: 'QR Scan Result'
                                );
                                break;

                              default:
                                break;


                            }


                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 0),
                            child: Material(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              elevation: 10.0,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                                  child: Row(
                                    children: [
                                      Icon(data[index].icon),
                                      SizedBox(width: 20,),
                                      Text(
                                        data[index].name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    DataCacheManager().showingPopup = false;
    Navigator.of(context).pop(false);
    return true;
  }
}
