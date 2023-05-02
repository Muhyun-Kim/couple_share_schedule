import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/widgets/partner_widget/partner_schedule_list.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PartnerMainScreenBody extends StatefulWidget {
  const PartnerMainScreenBody({super.key, required this.partnerUid});
  final String partnerUid;
  @override
  State<PartnerMainScreenBody> createState() => _PartnerMainScreenBodyState();
}

class _PartnerMainScreenBodyState extends State<PartnerMainScreenBody> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<String> _selectedEvents = [];

  Future<Map<DateTime, List<String>>> getPartnerSchedule() async {
    final partnerScheduleSnapshot = await FirebaseFirestore.instance
        .collection(widget.partnerUid)
        .orderBy("selectedDate")
        .get();
    final partnerSchedule = partnerScheduleSnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    for (var i = 0; i < partnerSchedule.length; i++) {
      final selectedDate =
          (partnerSchedule[i]['selectedDate'] as Timestamp).toDate();
      final DateTime selectedUtc =
          DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);
      final partnerScheduleInfo =
          partnerSchedule[i]['scheduleInfo'].cast<String>() as List<String>;
      partnerScheduleMap[selectedUtc] = partnerScheduleInfo;
    }
    return partnerScheduleMap;
  }

  var partnerScheduleMap = <DateTime, List<String>>{};

  @override
  void initState() {
    super.initState();
    getPartnerSchedule().then((value) {
      setState(() {
        partnerScheduleMap = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final partnerScheduleStream =
        FirebaseFirestore.instance.collection(widget.partnerUid).snapshots();
    return StreamBuilder<Object>(
        stream: partnerScheduleStream,
        builder: (context, snapshot) {
          return Column(
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
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(
                      () {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedEvents = partnerScheduleMap[selectedDay] ?? [];
                      },
                    );
                  },
                  eventLoader: (date) {
                    return partnerScheduleMap[date] ?? [];
                  },
                ),
              ),
              PartnerScheduleList(
                selectedEvents: _selectedEvents,
                focusedDay: _focusedDay,
              ),
            ],
          );
        });
  }
}
