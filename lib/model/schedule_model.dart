import 'package:http/http.dart';

class SchedModel {
  late final int schedId;
  late final String profName;
  late final String subject;
  late final String startTime;
  late final String endTime;
  late final String dayOfWeek;

  SchedModel({
    required this.schedId,
    required this.profName,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
  });
}