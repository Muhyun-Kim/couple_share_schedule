import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScheduleList extends StatefulWidget {
  const HomeScheduleList({
    super.key,
    required List<String> selectedEvents,
    required this.focusedDay,
  }) : _selectedEvents = selectedEvents;

  final List<String> _selectedEvents;
  final DateTime focusedDay;

  @override
  State<HomeScheduleList> createState() => _HomeScheduleListState();
}

class _HomeScheduleListState extends State<HomeScheduleList> {
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
                    onPressed: () {
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const HomeScreen(),
                        ),
                      );
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
