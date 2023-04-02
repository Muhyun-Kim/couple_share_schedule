import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleListModel {
  final DateTime selectedDate;
  final String startTime;
  final String endTime;
  final String scheduleTitle;
  final DocumentReference reference;

  ScheduleListModel({
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.scheduleTitle,
    required this.reference,
  });

  factory ScheduleListModel.fromFireStore(
      DocumentSnapshot<Map<DateTime, List<String>>> snapshot) {
    final data = snapshot.data()!;
    return ScheduleListModel(
      selectedDate: data['selectedDate'] as DateTime,
      startTime: data['startTime'] as String,
      endTime: data['endTime'] as String,
      scheduleTitle: data['scheduleTitle'] as String,
      reference: snapshot.reference,
    );
  }

  Map<DateTime, List<String>> toMap() {
    return {
      selectedDate: [startTime, endTime, scheduleTitle],
    };
  }
}
