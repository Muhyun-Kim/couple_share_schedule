//Author : muhyun-kim
//Modified : 2023/05/19
//Function : ログイン状態の時、最初表示される画面

import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleProvider =
    StateNotifierProvider<ScheduleState, Map<DateTime, List<String>>?>(
        (ref) => ScheduleState(ref));

class ScheduleState extends StateNotifier<Map<DateTime, List<String>>?> {
  ScheduleState(this.ref) : super(null);
  Ref ref;
}
