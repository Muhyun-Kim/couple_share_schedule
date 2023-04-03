import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleListModel {
  final String userId;
  final String userName;
  final DateTime selectedDate;
  final String startTime;
  final String endTime;
  final String scheduleTitle;
  final DocumentReference reference;

  ScheduleListModel({
    required this.userId,
    required this.userName,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.scheduleTitle,
    required this.reference,
  });

  factory ScheduleListModel.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return ScheduleListModel(
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      selectedDate: data['selectedDate'] as DateTime,
      startTime: data['startTime'] as String,
      endTime: data['endTime'] as String,
      scheduleTitle: data['scheduleTitle'] as String,
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "selectedDate": selectedDate,
      "scheduleInfo": [startTime, endTime, scheduleTitle],
    };
  }
}
