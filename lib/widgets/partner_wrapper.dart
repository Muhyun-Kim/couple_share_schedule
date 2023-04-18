import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/screens/partner_add_screen.dart';
import 'package:couple_share_schedule/screens/partner_main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PartnerWrapper extends StatefulWidget {
  const PartnerWrapper({super.key});

  @override
  State<PartnerWrapper> createState() => _PartnerWrapperState();
}

class _PartnerWrapperState extends State<PartnerWrapper> {
  Future getPartnerInfo() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final partnerSnapshot = await FirebaseFirestore.instance
        .collection(userId)
        .doc("partner")
        .get();
    final partnerInfo = partnerSnapshot.data();
    if (partnerInfo == null) {
      return null;
    } else {
      // print(partnerInfo["partnerUid"]);
      return partnerInfo;
    }
  }

  var partnerGetInfo;

  @override
  void initState() {
    super.initState();
    getPartnerInfo().then((value) {
      partnerGetInfo = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final partnerStream = FirebaseFirestore.instance
        .collection(userId)
        .doc("partner")
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: partnerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!.exists) {
          final partnerInfo = snapshot.data!.data();
          return const PartnerMainScreen();
        } else {
          return const PartnerAddScreen();
        }
      },
    );
  }
}
