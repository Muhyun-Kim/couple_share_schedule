//Author : muhyun-kim
//Modified : 2023/05/06
//Function : ログイン状態の時、最初表示される画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/schedule_list_model.dart';
import 'package:couple_share_schedule/provider/schedule_provider.dart';
import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:couple_share_schedule/screens/loading_screen.dart';
import 'package:couple_share_schedule/screens/mobile_scanner_screen.dart';
import 'package:couple_share_schedule/screens/partner_main_screen.dart';
import 'package:couple_share_schedule/widgets/add_schedule.dart';
import 'package:couple_share_schedule/widgets/home_widget/home_schedule_list.dart';
import 'package:couple_share_schedule/widgets/left_menu.dart';
import 'package:couple_share_schedule/widgets/left_menu_widget/full_image_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  /// カレンダーの初期設定
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // late CollectionReference<ScheduleListModel> schedulesReference;
  List<String> _selectedEvents = [];

  Future<void> setUserInitialValue() async {
    await currentUser!.updateDisplayName("ゲスト");
    await currentUser!.updatePhotoURL(
        "https://firebasestorage.googleapis.com/v0/b/coupleshareschedule.appspot.com/o/profileImg%2Fguest.png?alt=media&token=65859ba3-3aea-470c-9e21-b3bcc32c4a1b");
  }

  final partnerStream =
      FirebaseFirestore.instance.collection(userUid).doc("partner").snapshots();

  void _updateBody() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser!.displayName == null ||
        FirebaseAuth.instance.currentUser!.photoURL == null) {
      setUserInitialValue();
    }
    ref.read(scheduleProvider.notifier).getSchedule(userUid);
  }

  @override
  Widget build(BuildContext context) {
    var partnerInfo;

    // 現在のユーザー名を取得
    String currentUserName;
    if (ref.watch(currentUserProvider) == null) {
      currentUserName = FirebaseAuth.instance.currentUser!.displayName ?? "ゲスト";
    } else {
      currentUserName = ref.watch(currentUserProvider)!.displayName ?? "ゲスト";
    }

    // get schedule from provider
    Map<DateTime, List<String>> _myScheduleMap;
    _myScheduleMap = ref.watch(scheduleProvider);

    final CollectionReference<ScheduleListModel> schedulesReference =
        FirebaseFirestore.instance
            .collection(currentUser!.uid)
            .withConverter<ScheduleListModel>(
      fromFirestore: ((snapshot, _) {
        return ScheduleListModel.fromFireStore(snapshot);
      }),
      toFirestore: ((value, _) {
        return value.toMap();
      }),
    );

    //Icon button 定義
    IconButton _buildQrCodeIconButton(BuildContext context) {
      return IconButton(
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
        icon: const Icon(
          Icons.person_add_outlined,
        ),
      );
    }

    IconButton _buildPartnerIconButton(BuildContext context) {
      return IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PartnerMainScreen(
                partnerInfo: partnerInfo,
              ),
            ),
          );
        },
        icon: Icon(
          Icons.people_outlined,
        ),
      );
    }

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
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFFC3E99D),
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Color.fromARGB(255, 17, 20, 17),
              ),
              title: Text(
                currentUserName,
                style: const TextStyle(
                  color: Color.fromARGB(255, 7, 8, 7),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      builder: (BuildContext context) {
                        return AddSchedule(
                          focusedDay: _focusedDay,
                          schedulesReference: schedulesReference,
                          updateBody: _updateBody,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
                partnerInfo == null
                    ? _buildQrCodeIconButton(context)
                    : _buildPartnerIconButton(context),
              ],
            ),
            body: Builder(
              builder: (context) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCalendar(
                          locale: 'ja_JP',
                          focusedDay: _focusedDay,
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          calendarFormat: _calendarFormat,
                          availableCalendarFormats: const {
                            CalendarFormat.month: '週',
                            CalendarFormat.week: '月',
                          },
                          onFormatChanged: (format) {
                            setState(
                              () {
                                _calendarFormat = format;
                              },
                            );
                          },
                          onPageChanged: (focusedDay) {},
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(
                              () {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _selectedEvents =
                                    _myScheduleMap[selectedDay] ?? [];
                              },
                            );
                          },
                          eventLoader: (date) {
                            return _myScheduleMap[date] ?? [];
                          },
                        ),
                      ),
                      HomeScheduleList(
                        selectedEvents: _selectedEvents,
                        focusedDay: _focusedDay,
                        updateBody: _updateBody,
                      ),
                    ],
                  ),
                );
              },
            ),
            drawer: FractionallySizedBox(
              widthFactor: 0.6,
              child: LeftMenu(
                currentUser: currentUser,
              ),
            ),
          );
        }
      },
    );
  }
}
