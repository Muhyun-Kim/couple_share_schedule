import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/screens/home_screen.dart';
import 'package:couple_share_schedule/widgets/partner_main_screen_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PartnerMainScreen extends StatefulWidget {
  const PartnerMainScreen({super.key, required this.partnerInfo});
  final Map<String, dynamic> partnerInfo;

  @override
  State<PartnerMainScreen> createState() => _PartnerMainScreenState();
}

class _PartnerMainScreenState extends State<PartnerMainScreen> {
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
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 7, 202, 205),
              elevation: 0.0,
              title: Text(
                "${widget.partnerInfo["partnerName"]}のスケジュール",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.person_outline,
                  ),
                ),
              ],
            ),
            body: PartnerMainScreenBody(
              partnerUid: partnerUid,
            ),
          );
        });
  }
}
