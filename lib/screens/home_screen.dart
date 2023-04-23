//Author : muhyun-kim
//Modified : 2023/04/22
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:couple_share_schedule/screens/test.dart';
import 'package:couple_share_schedule/widgets/add_schedule.dart';
import 'package:couple_share_schedule/widgets/home_widget/home_schedule_list.dart';
import 'package:couple_share_schedule/widgets/left_menu.dart';
import 'package:couple_share_schedule/widgets/partner_widget/partner_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  /// カレンダーの初期設定
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  var _scheduleMap = <DateTime, List<String>>{};
  late CollectionReference<ScheduleListModel> schedulesReference;
  List<String> _selectedEvents = [];

  //FireStroeからスケジュール情報を持ってきて,table_calendarライブラリーに適用できるように型変換するfunction
  Future<Map<DateTime, List<String>>> getSchedule() async {
    final schduleListSnapshot = await FirebaseFirestore.instance
        .collection(currentUser!.uid)
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

  @override
  void initState() {
    super.initState();
    getSchedule().then((value) {
      setState(() {
        _scheduleMap = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    schedulesReference = FirebaseFirestore.instance
        .collection(currentUser!.uid)
        .withConverter<ScheduleListModel>(
      fromFirestore: ((snapshot, _) {
        return ScheduleListModel.fromFireStore(snapshot);
      }),
      toFirestore: ((value, _) {
        return value.toMap();
      }),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 202, 205),
        elevation: 0.0,
        title: Text(
          currentUser!.displayName.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          //テストのためのボタン
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const ProviderScope(child: Test());
                  },
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return AddSchedule(
                    focusedDay: _focusedDay,
                    schedulesReference: schedulesReference,
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PartnerWrapper(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite,
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  locale: 'ja_JP',
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarFormat: _calendarFormat,
                  availableCalendarFormats: const {
                    CalendarFormat.month: '週',
                    CalendarFormat.week: '月',
                  },
                  onFormatChanged: (format) {
                    setState(
                      () {
                        _calendarFormat = format;
                      },
                    );
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(
                      () {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedEvents = _scheduleMap[selectedDay] ?? [];
                      },
                    );
                  },
                  eventLoader: (date) {
                    return _scheduleMap[date] ?? [];
                  },
                ),
              ),
              //日程を表示する画面（後で変える）

              HomeScheduleList(
                selectedEvents: _selectedEvents,
                focusedDay: _focusedDay,
              ),
            ],
          );
        },
      ),
      drawer: leftMenu(context),
    );
  }
}
