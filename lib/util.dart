import 'package:intl/intl.dart';

class Util {
 static String getDateNow() {
   final DateTime now = DateTime.now();
   final DateFormat formatter = DateFormat('MMM dd, yyyy');
   final String formatted = formatter.format(now);
   return formatted;
 }
}