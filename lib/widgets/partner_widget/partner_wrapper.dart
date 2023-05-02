import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/screens/loading_screen.dart';
import 'package:couple_share_schedule/screens/partner_add_screen.dart';
import 'package:couple_share_schedule/screens/partner_main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final userUid = FirebaseAuth.instance.currentUser!.uid;

class PartnerWrapper extends StatefulWidget {
  const PartnerWrapper({super.key});

  @override
  State<PartnerWrapper> createState() => _PartnerWrapperState();
}

class _PartnerWrapperState extends State<PartnerWrapper> {
  final partnerStream =
      FirebaseFirestore.instance.collection(userUid).doc("partner").snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: partnerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasData && snapshot.data!.exists) {
          final partnerInfo = snapshot.data!.data() as Map<String, dynamic>;
          return PartnerMainScreen(
            partnerInfo: partnerInfo,
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return PartnerAddScreen(
            partnerUid: "UIDを読み取る",
          );
        }
      },
    );
  }
}
