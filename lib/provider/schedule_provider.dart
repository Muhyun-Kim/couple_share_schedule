//Author : muhyun-kim
//Modified : 2023/05/19
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? "";

final scheduleProvider =
    StateNotifierProvider<ScheduleState, Map<DateTime, List<String>>>(
        (ref) => ScheduleState(ref));

class ScheduleState extends StateNotifier<Map<DateTime, List<String>>> {
  ScheduleState(this.ref) : super({});
  Ref ref;

  void setSchedule(Map<DateTime, List<String>> schedule) {
    state = schedule;
    ref.invalidate(scheduleProvider);
  }

  var _scheduleMap = <DateTime, List<String>>{};
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<Map<DateTime, List<String>>> getSchedule() async {
    final schduleListSnapshot = await FirebaseFirestore.instance
        .collection(currentUser.uid)
        .orderBy("selectedDate")
        .get();
    final schedule = schduleListSnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    for (var i = 0; i < schedule.length; i++) {
      final selectedDate = (schedule[i]['selectedDate'] as Timestamp).toDate();
      final DateTime selectedUtc =
          DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);
      final scheduleInfo =
          schedule[i]['scheduleInfo'].cast<String>() as List<String>;
      _scheduleMap[selectedUtc] = scheduleInfo;
    }
    return _scheduleMap;
  }

  void updateSchedule() async {
    final value = await getSchedule();
    setSchedule(value);
  }
}
