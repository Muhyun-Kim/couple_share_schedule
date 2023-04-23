//Author : muhyun-kim
//Modified : 2023/04/22
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:couple_share_schedule/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSchedule extends StatefulWidget {
  final DateTime focusedDay;
  final CollectionReference<ScheduleListModel> schedulesReference;
  const AddSchedule(
      {Key? key, required this.focusedDay, required this.schedulesReference})
      : super(key: key);
  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final TextEditingController _startTimeInput = TextEditingController();
  final TextEditingController endTimeInput = TextEditingController();
  final TextEditingController scheduleInput = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;
  Map<String, dynamic>? scheduleGetInfo;

  
  Future getScheduleInfo() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docName = widget.focusedDay.toString().substring(0, 10);
    final schduleSnapshot =
        await FirebaseFirestore.instance.collection(userId).doc(docName).get();
    final scheduleInfo = schduleSnapshot.data();
    return scheduleInfo;
  }

  // エラーメッセージを表示するfunction
  void _showAlertDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(content: Text(errorMessage), actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"))
        ]);
      },
    );
  }

  @override
  void initState() {
    _startTimeInput.text = "";
    endTimeInput.text = "";
    super.initState();
    getScheduleInfo().then((value) {
      setState(() {
        scheduleGetInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM月dd日').format(widget.focusedDay);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(formattedDate),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Center(
                child: Column(
                  children: [
                    TextField(
                      controller: _startTimeInput,
                      decoration: const InputDecoration(
                        labelText: "開始時間",
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedStartTime = await showTimePicker(
                          initialTime:
                              TimeOfDay.fromDateTime(widget.focusedDay),
                          context: context,
                        );
                        if (pickedStartTime != null && mounted) {
                          DateTime parsedEndTime = DateFormat.jm().parse(
                              pickedStartTime.format(context).toString());
                          String formattedStartTime =
                              DateFormat('HH:mm').format(parsedEndTime);
                          setState(
                            () {
                              _startTimeInput.text = formattedStartTime;
                            },
                          );
                        }
                      },
                    ),
                    TextField(
                      controller: endTimeInput,
                      decoration: const InputDecoration(
                        labelText: "終了時間",
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedEndTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (pickedEndTime != null && mounted) {
                          DateTime parsedEndTime = DateFormat.jm()
                              .parse(pickedEndTime.format(context).toString());
                          String formattedEndTime =
                              DateFormat('HH:mm').format(parsedEndTime);
                          setState(
                            () {
                              endTimeInput.text = formattedEndTime;
                            },
                          );
                        }
                      },
                    ),
                    TextField(
                      controller: scheduleInput,
                      decoration: const InputDecoration(
                        hintText: "スケジュール入力欄",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_startTimeInput.text != "" &&
                            endTimeInput.text != "" &&
                            scheduleInput.text != "") {
                          final List scheduleInfo = [
                            "${_startTimeInput.text} - ${endTimeInput.text} : ${scheduleInput.text}"
                          ];
                          final newDocumentReference =
                              widget.schedulesReference.doc(
                            widget.focusedDay.toString().substring(0, 10),
                          );
                          final newSchedule = ScheduleListModel(
                            selectedDate: widget.focusedDay,
                            scheduleInfo: scheduleInfo,
                          );
                          if (scheduleGetInfo == null) {
                            newDocumentReference.set(newSchedule);
                          } else {
                            newDocumentReference.update({
                              "scheduleInfo":
                                  FieldValue.arrayUnion(scheduleInfo)
                            });
                          }
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HomeScreen(),
                            ),
                          );
                        } else if (scheduleInput.text != "") {
                          _showAlertDialog(context, "時間を入力してください");
                        } else {
                          _showAlertDialog(context, "スケジュールを入力してください");
                        }
                      },
                      child: const Text("保存"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
