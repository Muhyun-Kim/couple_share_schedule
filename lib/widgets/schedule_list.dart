import 'package:flutter/material.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({
    super.key,
    required List<String> selectedEvents,
  }) : _selectedEvents = selectedEvents;

  final List<String> _selectedEvents;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //selectedEventsを削除する機能を追加する
      height: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          final event = _selectedEvents[index];
          return Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(event),
                  IconButton(
                    onPressed: () {},
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
