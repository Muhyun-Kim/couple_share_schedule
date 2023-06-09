//Author : muhyun-kim
//Modified : 2023/04/22
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/db/firestore_db.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:couple_share_schedule/provider/schedule_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

class AddScheduleModal extends ConsumerStatefulWidget {
  final DateTime focusedDay;
  final CollectionReference<ScheduleListModel> schedulesReference;
  final Function updateBody;
  final List<String> selectedEvents;
  const AddScheduleModal(
      {Key? key,
      required this.selectedEvents,
      required this.focusedDay,
      required this.schedulesReference,
      required this.updateBody})
      : super(key: key);
  @override
  ConsumerState<AddScheduleModal> createState() => _AddScheduleModalState();
}

class _AddScheduleModalState extends ConsumerState<AddScheduleModal> {
  final TextEditingController _startTimeInput = TextEditingController();
  final TextEditingController _endTimeInput = TextEditingController();
  final TextEditingController _scheduleInput = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;
  Map<String, dynamic>? scheduleGetInfo;

  Future getScheduleInfo() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docName = widget.focusedDay.toString().substring(0, 10);
    final scheduleSnapshot = await db.collection(userId).doc(docName).get();
    final scheduleInfo = scheduleSnapshot.data();
    return scheduleInfo;
  }

  // エラーメッセージを表示するfunction
  void _showRoundedAlertDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _startTimeInput.text = "";
    _endTimeInput.text = "";
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
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formattedDate,
                      style: GoogleFonts.sawarabiGothic(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Color.fromARGB(255, 129, 129, 129),
                  ),
                ),
              ],
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
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          initialTime:
                              TimeOfDay.fromDateTime(widget.focusedDay),
                          context: context,
                        );
                        if (pickedStartTime != null && mounted) {
                          final date = DateTime.now();
                          final parsedStartTime = DateFormat.Hm()
                              .format(date.applied(pickedStartTime));
                          setState(
                            () {
                              _startTimeInput.text = parsedStartTime;
                            },
                          );
                        }
                      },
                    ),
                    TextField(
                      controller: _endTimeInput,
                      decoration: const InputDecoration(
                        labelText: "終了時間",
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedEndTime = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (pickedEndTime != null && mounted) {
                          final date = DateTime.now();
                          final parsedEndTime = DateFormat.Hm()
                              .format(date.applied(pickedEndTime));
                          setState(
                            () {
                              _endTimeInput.text = parsedEndTime;
                            },
                          );
                        }
                      },
                    ),
                    TextField(
                      controller: _scheduleInput,
                      decoration: const InputDecoration(
                        hintText: "スケジュール入力欄",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_startTimeInput.text != "" &&
                            _endTimeInput.text != "" &&
                            _scheduleInput.text != "") {
                          final scheduleInfo =
                              "${_startTimeInput.text} - ${_endTimeInput.text} : ${_scheduleInput.text}";
                          final scheduleInfoList = [scheduleInfo];
                          final newDocumentReference =
                              widget.schedulesReference.doc(
                            widget.focusedDay.toString().substring(0, 10),
                          );
                          final newSchedule = ScheduleListModel(
                            selectedDate: widget.focusedDay,
                            scheduleInfo: scheduleInfoList,
                          );
                          if (scheduleGetInfo == null) {
                            await newDocumentReference.set(newSchedule);
                          } else {
                            await newDocumentReference.update({
                              "scheduleInfo":
                                  FieldValue.arrayUnion(scheduleInfoList)
                            });
                          }
                          if (mounted) {
                            await ref
                                .read(scheduleProvider.notifier)
                                .getSchedule(userId);
                            await widget.updateBody();
                            setState(() {
                              widget.selectedEvents.add(scheduleInfo);
                            });
                            Navigator.pop(context);
                          }
                        } else if (_scheduleInput.text != "") {
                          _showRoundedAlertDialog(context, "時間を入力してください");
                        } else {
                          _showRoundedAlertDialog(context, "スケジュールを入力してください");
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
