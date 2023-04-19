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

final userId = FirebaseAuth.instance.currentUser!.uid;
final partnerStream =
    FirebaseFirestore.instance.collection(userId).doc("partner").snapshots();

class _PartnerWrapperState extends State<PartnerWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: partnerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!.exists) {
          return const PartnerMainScreen();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return const PartnerAddScreen();
        }
      },
    );
  }
}
