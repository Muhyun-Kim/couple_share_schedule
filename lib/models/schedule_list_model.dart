//Author : muhyun-kim
//Modified : 2023/04/22
//Function : スケジュール情報モデル

import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleListModel {
  final DateTime selectedDate;
  final List scheduleInfo;

  ScheduleListModel({
    required this.selectedDate,
    required this.scheduleInfo,
  });

  factory ScheduleListModel.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final DateTime selectedDate = data['selectedDate'].toDate();
    final DateTime selectedUtc =
        DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);
    final scheduleInfo = data['scheduleInfo'];
    return ScheduleListModel(
      selectedDate: selectedUtc,
      scheduleInfo: scheduleInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "selectedDate": selectedDate,
      "scheduleInfo": scheduleInfo,
    };
  }
}
