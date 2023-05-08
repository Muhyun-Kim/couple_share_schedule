import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:couple_share_schedule/screens/login_screen.dart';
import 'package:couple_share_schedule/widgets/left_menu_widget/full_image_screen.dart';
import 'package:couple_share_schedule/widgets/left_menu_widget/user_qrcode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LeftMenu extends ConsumerStatefulWidget {
  LeftMenu({super.key, required this.currentUser});

  User? currentUser;

  @override
  ConsumerState<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends ConsumerState<LeftMenu> {
  void _opnePrivacyPolicy() async {
    Uri url = Uri.parse(
        'https://muhyun-kim.github.io/couple_share_schedule_privacy/privacy_jp.html');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'このURLにはアクセスできません';
    }
  }

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
    final TextEditingController deleteAccountInput = TextEditingController();

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
            title: Text("ID: ${widget.currentUser!.uid}"),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('変更'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await widget.currentUser!
                                  .updateDisplayName(displayNameInput.text);
                              final user = FirebaseAuth.instance.currentUser!;
                              final userProvider =
                                  ref.read(currentUserProvider.notifier);
                              userProvider.setUser(user);
                            },
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
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text("利用規約"),
            onTap: _opnePrivacyPolicy,
          ),
          ListTile(
            title: const Text("ログアウト"),
            onTap: () => FirebaseAuth.instance.signOut(),
          ),
          ListTile(
            title: const Text("アカウント削除"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("アカウントを削除確？"),
                    content: Text(
                        "アカウントを削除すると、すべてのデータが削除されます。削除するなら、「削除」と入力してください。"),
                    actions: <Widget>[
                      TextField(
                        controller: deleteAccountInput,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "削除",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (deleteAccountInput.text == "削除") {
                                await widget.currentUser!.delete();
                                widget.currentUser = null;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("確認"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text("キャンセル"),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
