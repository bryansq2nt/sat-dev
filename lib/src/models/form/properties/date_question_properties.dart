import 'package:intl/intl.dart' show DateFormat;

enum DateType {datetime, date,time,year,month,day}
class DateQuestionProperties {
  // final DateTime min = DateTime(1970);
  // final DateTime current = DateTime.now();
  // final DateTime max = DateTime.now();
  // final DateFormat format = DateFormat('dd-MM-yyyy');
  // final DateType type = DateType.complete;

  final DateTime? min;
  final DateTime current = DateTime.now();
  final DateTime? max;
  final DateFormat format;
  final DateType type;

  DateQuestionProperties({this.min,this.max,required this.format, required this.type});



}