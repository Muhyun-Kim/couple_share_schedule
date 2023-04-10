import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  final CollectionReference<ScheduleListModel> schedulesReference;
  const Test({Key? key, required this.schedulesReference}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    CollectionReference schedule =
        FirebaseFirestore.instance.collection('sZIdsUZ3roZqQ5MjEZqQSoHoVbG2');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<ScheduleListModel>>(
              stream: widget.schedulesReference.snapshots(),
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final schedule = docs[index].data();
                    return ListTile(
                      title: Text(schedule.selectedDate.toString()),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
