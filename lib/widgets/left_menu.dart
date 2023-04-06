import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Drawer leftMenu() {
  var userName = FirebaseAuth.instance.currentUser?.displayName;
  var userImg = FirebaseAuth.instance.currentUser?.photoURL;
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 7, 202, 205),
          ),
          child: Column(
            children: [
              Text(
                userName ?? "GuestUser",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Image(
                image: NetworkImage(userImg ?? ""),
              ),
            ],
          ),
        ),
        ListTile(
          title: const Text("ログアウト"),
          onTap: () => FirebaseAuth.instance.signOut(),
        ),
      ],
    ),
  );
}
