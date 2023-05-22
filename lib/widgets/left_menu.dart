import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:couple_share_schedule/screens/login_screen.dart';
import 'package:couple_share_schedule/widgets/left_menu_widget/full_image_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LeftMenu extends ConsumerStatefulWidget {
  LeftMenu({super.key, required this.currentUser});

  final User? currentUser;

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
    User currentUser;
    String currentUserName;
    String currentUserPhotoURL;
    if (ref.watch(currentUserProvider) == null) {
      currentUser = FirebaseAuth.instance.currentUser!;
      currentUserPhotoURL = FirebaseAuth.instance.currentUser!.photoURL ?? "";
      currentUserName = FirebaseAuth.instance.currentUser!.displayName ?? "";
    } else {
      currentUser = ref.watch(currentUserProvider)!;
      currentUserPhotoURL = ref.watch(currentUserProvider)!.photoURL ?? "";
      currentUserName = ref.watch(currentUserProvider)!.displayName ?? "";
    }

    final TextEditingController displayNameInput = TextEditingController();
    final TextEditingController deleteAccountInput = TextEditingController();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 270,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFC3E99D),
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
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          currentUserPhotoURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentUserName,
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'ユーザー名を変更しますか？',
                                    textAlign: TextAlign.left,
                                  ),
                                  actions: <Widget>[
                                    TextField(
                                      controller: displayNameInput,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: currentUserName,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: const Text('変更'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await currentUser.updateDisplayName(
                                                displayNameInput.text);
                                            final user = FirebaseAuth
                                                .instance.currentUser!;
                                            final userProvider = ref.read(
                                                currentUserProvider.notifier);
                                            userProvider.setUser(user);
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
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
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.security_outlined,
            ),
            title: Text("利用規約"),
            onTap: _opnePrivacyPolicy,
          ),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
            ),
            title: const Text("ログアウト"),
            onTap: () => FirebaseAuth.instance.signOut(),
          ),
          ListTile(
            iconColor: Colors.red,
            textColor: Colors.red,
            leading: Icon(
              Icons.person_off_outlined,
            ),
            title: const Text("アカウント削除"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
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
                                await currentUser.delete().catchError(
                                      (error) => showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text("削除するなら再ログインが必要です"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("OK"),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
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
                            child: Text("削除"),
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
