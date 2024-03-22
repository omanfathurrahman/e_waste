import 'package:intl/intl.dart';

String formatDate(String date) {
  final DateTime dateTime = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(dateTime);
}
