//Author : muhyun-kim
//Modified : 2023/03/15
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:couple_share_schedule/screens/partner_main_screen.dart';
import 'package:couple_share_schedule/screens/test.dart';
import 'package:couple_share_schedule/widgets/add_schedule.dart';
import 'package:couple_share_schedule/widgets/left_menu.dart';
import 'package:couple_share_schedule/widgets/schedule_list.dart';
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
  final Stream<QuerySnapshot> _scheduleStream =
      FirebaseFirestore.instance.collection('schedule').snapshots();

  /// ログイン状態の時、最初表示される画面
  final _nameTextEditingController =
      Provider.autoDispose<TextEditingController>(
    (_) => TextEditingController(),
  );

  /// カレンダーの設定
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late CollectionReference<ScheduleListModel> schedulesReference;

  Future<Map<DateTime, List<String>>> getSchedule() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    Map<DateTime, List<String>> scheduleMap = {};

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
    final schduleListSnapshot = await FirebaseFirestore.instance
        .collection(userId)
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
      scheduleMap[selectedUtc] = scheduleInfo;
    }
    return scheduleMap;
  }

  var scheduleMap = <DateTime, List<String>>{};

  @override
  void initState() {
    super.initState();
    getSchedule().then((value) {
      setState(() {
        scheduleMap = value;
      });
    });
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
      body: Builder(builder: (context) {
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
                      _selectedEvents = scheduleMap[selectedDay] ?? [];
                    },
                  );
                },
                eventLoader: (date) {
                  return scheduleMap[date] ?? [];
                },
              ),
            ),
            //日程を表示する画面（後で変える）

            ScheduleList(selectedEvents: _selectedEvents, focusedDay: _focusedDay,),
          ],
        );
      }),
      drawer: leftMenu(),
    );
  }
}
