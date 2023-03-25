//Author : muhyun-kim
//Modified : 2023/03/15
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/screens/partner_main_screen.dart';
import 'package:couple_share_schedule/widgets/add_schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  // ignore: unused_field
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  //このサンプルは後で要変更
  final sampleMap = {
    DateTime.utc(2023, 3, 7): [
      'firstEvent',
      'secodnEvent',
      'five',
    ],
    DateTime.utc(2023, 3, 20): ['thirdEvent', 'fourthEvent']
  };

  List<String> _selectedEvents = [];

  var userName = FirebaseAuth.instance.currentUser?.displayName;
  var userImg = FirebaseAuth.instance.currentUser?.photoURL;
    final userId = FirebaseAuth.instance.currentUser?.uid;


  void instance() {
    super.initState();
  }


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
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return AddSchedule(focusedDay: _focusedDay);
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
                    _selectedEvents = sampleMap[selectedDay] ?? [];
                  },
                );
              },
              eventLoader: (date) {
                return sampleMap[date] ?? [];
              },
            ),
          ),
          //日程を表示する画面（後で変える）

          Expanded(
            child: ListView.builder(
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 7, 202, 205),
              ),
              child: Column(
                children: [
                  Text(
                    userName ?? "GuestUser",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Image(
                    image: NetworkImage(userImg ?? ""),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("ログアウト"),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
