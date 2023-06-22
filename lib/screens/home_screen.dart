//Author : muhyun-kim
//Modified : 2023/05/06
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:couple_share_schedule/screens/loading_screen.dart';
import 'package:couple_share_schedule/screens/mobile_scanner_screen.dart';
import 'package:couple_share_schedule/screens/partner_schedule_screen.dart';
import 'package:couple_share_schedule/widgets/home_widget/my_schedule_screen_builder.dart';
import 'package:couple_share_schedule/widgets/left_menu.dart';
import 'package:couple_share_schedule/widgets/left_menu_widget/full_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final partnerStream =
      FirebaseFirestore.instance.collection(userUid).doc("partner").snapshots();

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var partnerInfo;
    final currentUser = ref.read(currentUserProvider);

    return StreamBuilder(
      stream: partnerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else {
          if (snapshot.data?.data() != null) {
            partnerInfo = snapshot.data?.data() as Map<String, dynamic>;
          } else {
            partnerInfo = null;
          }
          return DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: Container(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: () => _scaffoldKey.currentState!.openDrawer(),
                    child: ClipOval(
                      child: Image.network(currentUser!.photoURL.toString()),
                    ),
                  ),
                ),
                title: SizedBox(
                  height: 48,
                  child: Image.asset(
                    'assets/images/logo_center.png',
                  ),
                ),
                backgroundColor: Color(0xFFC3E99D),
                elevation: 0.0,
                iconTheme: IconThemeData(
                  color: Color.fromARGB(255, 17, 20, 17),
                ),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        "my schedule",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 17, 20, 17),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "partner schedule",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 17, 20, 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  MyScheduleScreen(),
                  partnerInfo == null
                      ? Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MobileScannerScreen(
                                    partnerUid: "",
                                  ),
                                ),
                              );
                            },
                            child: Text("パートナーを追加"),
                          ),
                        )
                      : PartnerScheduleScreen(
                          partnerInfo: partnerInfo,
                        ),
                ],
              ),
              drawer: FractionallySizedBox(
                widthFactor: 0.6,
                child: LeftMenu(
                  currentUser: currentUser,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
