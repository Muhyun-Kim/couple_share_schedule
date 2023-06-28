import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PartnerScheduleList extends StatefulWidget {
  const PartnerScheduleList({
    super.key,
    required List<String> selectedEvents,
    required this.focusedDay,
  }) : _selectedEvents = selectedEvents;

  final List<String> _selectedEvents;
  final DateTime focusedDay;
  @override
  State<PartnerScheduleList> createState() => _PartnerScheduleListState();
}

class _PartnerScheduleListState extends State<PartnerScheduleList> {

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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
