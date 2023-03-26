import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/schedule_model.dart';
import 'package:flutter/material.dart';

class ScheduleService extends ChangeNotifier {
  List<ScheduleModel> schedule = [];

  Future<void> getSchedule() async {
    var collection = await FirebaseFirestore.instance
        .collection("sZIdsUZ3roZqQ5MjEZqQSoHoVbG2")
        .get();
    var scheduleList = collection.docs
        .map(
          (doc) => ScheduleModel(
            doc["startTime"],
            doc["endTime"],
            doc["scheduleTitle"],
          ),
        )
        .toList();
    schedule = scheduleList;
    notifyListeners();
  }
}
