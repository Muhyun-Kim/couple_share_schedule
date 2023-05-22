import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/provider/schedule_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScheduleList extends ConsumerStatefulWidget {
  const HomeScheduleList({
    required List<String> selectedEvents,
    required this.focusedDay,
    required this.updateBody,
  }) : _selectedEvents = selectedEvents;

  final List<String> _selectedEvents;
  final DateTime focusedDay;
  final Function updateBody;

  @override
  ConsumerState<HomeScheduleList> createState() => _HomeScheduleListState();
}

class _HomeScheduleListState extends ConsumerState<HomeScheduleList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //selectedEventsを削除する機能を追加する
      height: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget._selectedEvents.length,
        itemBuilder: (context, index) {
          final event = widget._selectedEvents[index];
          return Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(event),
                  IconButton(
                    onPressed: () async {
                      final userId = FirebaseAuth.instance.currentUser!.uid;
                      final docName =
                          widget.focusedDay.toString().substring(0, 10);
                      final docRef = FirebaseFirestore.instance
                          .collection(userId)
                          .doc(docName);
                      final deleteScheduleInfo = {
                        'scheduleInfo': FieldValue.arrayRemove([event]),
                      };
                      docRef.update(deleteScheduleInfo);
                      await ref
                          .read(scheduleProvider.notifier)
                          .getSchedule(userId);
                      widget.updateBody();
                      setState(() {
                        widget._selectedEvents.remove(event);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
