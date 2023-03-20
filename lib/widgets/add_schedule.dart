//Author : muhyun-kim
//Modified : 2023/03/20
//Function : ログイン状態の時、最初表示される画面

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSchedule extends StatelessWidget {
  final DateTime focusedDay;

  const AddSchedule({Key? key, required this.focusedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM月dd日').format(focusedDay);
    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () => Navigator.pop(context),
              ),
              Text(formattedDate)
            ],
          ),
        ],
      ),
    );
  }
}
