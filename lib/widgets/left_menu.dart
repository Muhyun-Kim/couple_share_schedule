import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:couple_share_schedule/widgets/left_menu_widget/full_image_screen.dart';
import 'package:couple_share_schedule/widgets/left_menu_widget/user_qrcode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeftMenu extends ConsumerStatefulWidget {
  const LeftMenu({super.key, required this.currentUser});

  final User currentUser;

  @override
  ConsumerState<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends ConsumerState<LeftMenu> {
  @override
  Widget build(BuildContext context) {
    String currentUserName;
    if (ref.watch(currentUserProvider) == null) {
      currentUserName = FirebaseAuth.instance.currentUser!.displayName ?? "";
    } else {
      currentUserName = ref.watch(currentUserProvider)!.displayName ?? "";
    }

    String currentUserPhotoURL;
    if (ref.watch(currentUserProvider) == null) {
      currentUserPhotoURL = FirebaseAuth.instance.currentUser!.photoURL ?? "";
    } else {
      currentUserPhotoURL = ref.watch(currentUserProvider)!.photoURL ?? "";
    }

    final TextEditingController displayNameInput = TextEditingController();
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
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FullImageScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image(
                      image: NetworkImage(currentUserPhotoURL),
                    ),
                  ),
                ],
              ),
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
            title: Text(currentUserName),
            onTap: () {
              showDialog(
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
                          await widget.currentUser
                              .updateDisplayName(displayNameInput.text);
                          final user = FirebaseAuth.instance.currentUser!;
                          final userProvider =
                              ref.read(currentUserProvider.notifier);
                          userProvider.setUser(user);
                        },
                      ),
                    ],
                  );
                },
              );
            },
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
