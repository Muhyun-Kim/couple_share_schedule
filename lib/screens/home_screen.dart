//Author : muhyun-kim
//Modified : 2023/05/06
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:couple_share_schedule/screens/mobile_scanner_screen.dart';
import 'package:couple_share_schedule/widgets/add_schedule.dart';
import 'package:couple_share_schedule/widgets/home_widget/home_schedule_list.dart';
import 'package:couple_share_schedule/widgets/left_menu.dart';
import 'package:couple_share_schedule/widgets/partner_widget/partner_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

  Future<void> updateSchedule() async {
    final value = await getSchedule();
    setState(() {
      _scheduleMap = value;
    });
  }

  Future<void> setUserInitialValue() async {
    await currentUser!.updateDisplayName("ゲスト");
    await currentUser!.updatePhotoURL(
        "https://firebasestorage.googleapis.com/v0/b/coupleshareschedule.appspot.com/o/profileImg%2Fguest.png?alt=media&token=65859ba3-3aea-470c-9e21-b3bcc32c4a1b");
  }

  @override
  void initState() {
    super.initState();
    updateSchedule();
    if (FirebaseAuth.instance.currentUser!.displayName == null ||
        FirebaseAuth.instance.currentUser!.photoURL == null) {
      setUserInitialValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentUserName;
    if (ref.watch(currentUserProvider) == null) {
      currentUserName = FirebaseAuth.instance.currentUser!.displayName ?? "ゲスト";
    } else {
      currentUserName = ref.watch(currentUserProvider)!.displayName ?? "ゲスト";
    }

    final CollectionReference<ScheduleListModel> schedulesReference =
        FirebaseFirestore.instance
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
        backgroundColor: Color(0xFFC3E99D),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 17, 20, 17),
        ),
        title: Text(
          currentUserName,
          style: const TextStyle(
            color: Color.fromARGB(255, 7, 8, 7),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
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
              Icons.person_add_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MobileScannerScreen(
                    partnerUid: "QRコード取得",
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.favorite,
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    locale: 'ja_JP',
                    focusedDay: _focusedDay,
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
                    onPageChanged: (focusedDay) {},
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
                HomeScheduleList(
                  selectedEvents: _selectedEvents,
                  focusedDay: _focusedDay,
                  updateSchedule: updateSchedule,
                  scheduleMap: _scheduleMap,
                ),
              ],
            ),
          );
        },
      ),
      drawer: LeftMenu(
        currentUser: currentUser,
      ),
    );
  }
}
