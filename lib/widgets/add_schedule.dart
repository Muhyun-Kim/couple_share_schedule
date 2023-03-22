//Author : muhyun-kim
//Modified : 2023/03/20
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSchedule extends StatefulWidget {
  final DateTime focusedDay;

  const AddSchedule({Key? key, required this.focusedDay}) : super(key: key);

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final TextEditingController startTimeInput = TextEditingController();
  final TextEditingController endTimeInput = TextEditingController();
  final TextEditingController scheduleInput = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    startTimeInput.text = "";
    endTimeInput.text = "";
    super.initState();
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
                      controller: startTimeInput,
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
                              startTimeInput.text = formattedStartTime;
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
                        if (startTimeInput.text != "" &&
                            endTimeInput.text != "" &&
                            scheduleInput.text != "") {
                          var scheduleInfo = <String, String>{
                            "startTime": startTimeInput.text,
                            "endTime": endTimeInput.text,
                            "scheduleTitle": scheduleInput.text,
                          };
                          FirebaseFirestore.instance
                              .collection("$userId")
                              .doc(formattedDate)
                              .set(scheduleInfo);
                        } else if (scheduleInput.text != "") {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text("スケジュールを入力してください"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            },
                          );
                        } else {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text("時間を入力してください"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            },
                          );
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
