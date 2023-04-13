//Author : muhyun-kim
//Modified : 2023/03/15
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:couple_share_schedule/screens/partner_main_screen.dart';
import 'package:couple_share_schedule/screens/test.dart';
import 'package:couple_share_schedule/widgets/add_schedule.dart';
import 'package:couple_share_schedule/widgets/left_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userName = FirebaseAuth.instance.currentUser?.displayName;
  var userImg = FirebaseAuth.instance.currentUser?.photoURL;
  String? userId;

  /// ログイン状態の時、最初表示される画面
  final _nameTextEditingController =
      Provider.autoDispose<TextEditingController>(
    (_) => TextEditingController(),
  );

  /// カレンダーの設定
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  //このサンプルは後で要変更
  final Map<DateTime, List<String>> sampleScheduleList = {
    DateTime.utc(2023, 4, 07): [
      'firstEvent',
    ],
    DateTime.utc(2023, 4, 20): ['thirdEvent', 'fourthEvent'],
    DateTime.utc(2023, 4, 10): ["test"]
  };

  late CollectionReference<ScheduleListModel> schedulesReference;

  Future getSchedule() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    Map<DateTime, List> scheduleMap = {};

    schedulesReference = FirebaseFirestore.instance
        .collection(userId)
        .withConverter<ScheduleListModel>(
      fromFirestore: ((snapshot, _) {
        return ScheduleListModel.fromFireStore(snapshot);
      }),
      toFirestore: ((value, _) {
        return value.toMap();
      }),
    );
    final QuerySnapshot schduleListSnapshot = await FirebaseFirestore.instance
        .collection(userId)
        .orderBy("selectedDate")
        .get();
    final schedule = schduleListSnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    for (var i = 0; i < schedule.length; i++) {
      print(schedule[i]);
    }
    return scheduleMap;
  }

  @override
  void initState() {
    super.initState();
    getSchedule();
  }

  List<String> _selectedEvents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 202, 205),
        elevation: 0.0,
        title: Text(
          userName ?? "Guest",
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
                  builder: (context) => const PartnerMainScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite,
            ),
          ),
        ],
      ),
      body: Column(
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
                    _selectedEvents = sampleScheduleList[selectedDay] ?? [];
                  },
                );
              },
              eventLoader: (date) {
                return sampleScheduleList[date] ?? [];
              },
            ),
          ),
          //日程を表示する画面（後で変える）

          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedEvents[index];
                return Card(
                  child: ListTile(
                    title: Text(event),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: leftMenu(),
    );
  }
}
