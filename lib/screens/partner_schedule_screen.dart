//Author : muhyun-kim
//Modified : 2023/06/08
//Function : パートナースケジュール画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/partner_widget/partner_main_screen_body.dart';

class PartnerScheduleScreen extends ConsumerStatefulWidget {
  const PartnerScheduleScreen({super.key, required this.partnerInfo});
  final Map<String, dynamic> partnerInfo;

  @override
  ConsumerState<PartnerScheduleScreen> createState() =>
      _PartnerScheduleScreenState();
}

class _PartnerScheduleScreenState extends ConsumerState<PartnerScheduleScreen> {
  final partnerInfoStream = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.uid)
      .doc("partner")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final partnerUid = widget.partnerInfo["partnerUid"];
    return StreamBuilder<Object>(
      stream: partnerInfoStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: PartnerMainScreenBody(
            partnerUid: partnerUid,
          ),
        );
      },
    );
  }
}
