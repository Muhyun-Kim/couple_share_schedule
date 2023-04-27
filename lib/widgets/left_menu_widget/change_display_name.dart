import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> changeDisplayName(
  BuildContext context,
  User currentUser,
  String currentUserName,
) {
  final TextEditingController displayNameInput = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('ユーザー名を変更しますか？'),
        content: const Text(""),
        actions: <Widget>[
          TextField(
            controller: displayNameInput,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: currentUserName,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('変更'),
            onPressed: () async {
              Navigator.of(context).pop();
              await currentUser.updateDisplayName(displayNameInput.text);
            },
          ),
        ],
      );
    },
  );
}
