import 'package:couple_share_schedule/widgets/user_qrcode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Drawer leftMenu(BuildContext context) {
  final currentUser = FirebaseAuth.instance.currentUser!;

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 7, 202, 205),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7),
            ),
          ),
          child: Column(
            children: [
              Image(
                image: NetworkImage(currentUser.photoURL ?? ""),
              ),
            ],
          ),
        ),
        ListTile(
          title: Text("ID: ${currentUser.uid}"),
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext buildContext) {
                return const UserQRCode();
              },
            );
          },
        ),
        ListTile(
          title: Text(currentUser.displayName ?? "Guest"),
          onTap: () {
            //　名前変更画面追加
          },
        ),
        const ListTile(
          title: Text("利用規約"),
        ),
        ListTile(
          title: const Text("ログアウト"),
          onTap: () => FirebaseAuth.instance.signOut(),
        ),
      ],
    ),
  );
}
