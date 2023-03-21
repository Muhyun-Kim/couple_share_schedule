//Author : muhyun-kim
//Modified : 2023/03/20
//Function : ログイン状態の時、最初表示される画面

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
      height: MediaQuery.of(context).size.height * 0.4,
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
                      onPressed: () {
                        print(formattedDate);
                        print(startTimeInput.text);
                        print(endTimeInput.text);
                        print(scheduleInput.text);
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
