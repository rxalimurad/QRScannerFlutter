import 'package:flutter/cupertino.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(itemBuilder: (context, index) {
      return Center(child: Text("$index"));
    }, itemCount: 1000,);
  }
}