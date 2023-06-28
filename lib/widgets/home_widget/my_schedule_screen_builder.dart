import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/db/firestore_db.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:couple_share_schedule/provider/schedule_provider.dart';
import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:couple_share_schedule/widgets/home_widget/home_schedule_list.dart';
import 'package:couple_share_schedule/widgets/modal_widget/add_schedule_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class MyScheduleScreen extends ConsumerStatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyScheduleScreenState();
}

class _MyScheduleScreenState extends ConsumerState<MyScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> _selectedEvents = [];

  void _updateBody() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<String>> _myScheduleMap;
    final userUid = ref.watch(currentUserProvider)!.uid;
    _myScheduleMap = ref.watch(scheduleProvider);
    ref.read(scheduleProvider.notifier).getSchedule(userUid);
    final currentUser = ref.read(currentUserProvider);
    final CollectionReference<ScheduleListModel> schedulesReference =
        db
            .collection(currentUser!.uid)
            .withConverter<ScheduleListModel>(
      fromFirestore: ((snapshot, _) {
        return ScheduleListModel.fromFireStore(snapshot);
      }),
      toFirestore: ((value, _) {
        return value.toMap();
      }),
    );
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SingleChildScrollView(
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
                          _selectedEvents = _myScheduleMap[selectedDay] ?? [];
                        },
                      );
                    },
                    eventLoader: (date) {
                      return _myScheduleMap[date] ?? [];
                    },
                  ),
                ),
                HomeScheduleList(
                  selectedEvents: _selectedEvents,
                  focusedDay: _focusedDay,
                  updateBody: _updateBody,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                builder: (BuildContext context) {
                  return AddScheduleModal(
                    selectedEvents: _selectedEvents,
                    focusedDay: _focusedDay,
                    schedulesReference: schedulesReference,
                    updateBody: _updateBody,
                  );
                },
              );
            },
            backgroundColor: Color(0xFFC3E99D),
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
