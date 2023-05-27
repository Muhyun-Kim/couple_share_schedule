import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/provider/schedule_provider.dart';
import 'package:couple_share_schedule/widgets/left_menu_widget/full_image_screen.dart';
import 'package:couple_share_schedule/widgets/modal_widget/add_schedule_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class UpdateScheduleModal extends StatefulHookConsumerWidget {
  const UpdateScheduleModal({
    super.key,
    required this.focusedDay,
    required this.event,
    required List<String> selectedEvents,
    required this.docRef,
    required this.updateBody,
  }) : _selectedEvents = selectedEvents;

  final List<String> _selectedEvents;
  final DateTime focusedDay;
  final String event;
  final DocumentReference<Map<String, dynamic>> docRef;
  final Function updateBody;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateScheduleModalState();
}

class _UpdateScheduleModalState extends ConsumerState<UpdateScheduleModal> {
  final TextEditingController _startTimeInput = TextEditingController();
  final TextEditingController _endTimeInput = TextEditingController();
  final TextEditingController _scheduleInput = TextEditingController();

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
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docName = widget.focusedDay.toString().substring(0, 10);
    final docRef = FirebaseFirestore.instance.collection(userId).doc(docName);
    print(docRef);
    final formattedDate = DateFormat('MM月dd日').format(widget.focusedDay);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
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
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Color.fromARGB(255, 129, 129, 129),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Center(
                child: Column(
                  children: [
                    TextField(
                      controller: _startTimeInput,
                      decoration: const InputDecoration(
                        labelText: '開始時間',
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
                          final scheudleInfo =
                              "${_startTimeInput.text} - ${_endTimeInput.text} : ${_scheduleInput.text}";
                          final scheduleInfoList = [scheudleInfo];
                          final deleteSchedule = {
                            'scheduleInfo':
                                FieldValue.arrayRemove([widget.event]),
                          };
                          final updateSchedule = {
                            'scheduleInfo':
                                FieldValue.arrayUnion(scheduleInfoList),
                          };
                          await widget.docRef.update(deleteSchedule);
                          await widget.docRef.update(updateSchedule);
                          ref
                              .read(scheduleProvider.notifier)
                              .getSchedule(userUid);
                          await widget.updateBody();
                          setState(() {
                            widget._selectedEvents.remove(widget.event);
                            widget._selectedEvents.add(scheudleInfo);
                          });
                          Navigator.pop(context);
                        } else if (_scheduleInput.text != "") {
                          _showRoundedAlertDialog(context, "時間を入力してください");
                        } else {
                          _showRoundedAlertDialog(context, "スケジュールを入力してください");
                        }
                      },
                      child: Text("変更"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
