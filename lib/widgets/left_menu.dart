import 'package:couple_share_schedule/widgets/left_menu_widget/change_display_name.dart';
import 'package:couple_share_schedule/widgets/user_qrcode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeftMenu extends StatefulWidget {
  const LeftMenu(
      {super.key, required this.currentUser, required this.currentUserName});

  final User currentUser;
  final String currentUserName;

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  @override
  Widget build(BuildContext context) {
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
                  image: NetworkImage(widget.currentUser.photoURL ?? ""),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("ID: ${widget.currentUser.uid}"),
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
            title: Text(widget.currentUserName),
            onTap: () {
              changeDisplayName(
                  context, widget.currentUser, widget.currentUserName);
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
}
