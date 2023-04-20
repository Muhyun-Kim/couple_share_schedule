import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PartnerAddScreen extends StatefulWidget {
  const PartnerAddScreen({super.key});

  @override
  State<PartnerAddScreen> createState() => _PartnerAddScreenState();
}

class _PartnerAddScreenState extends State<PartnerAddScreen> {
  final TextEditingController partnerUidInput = TextEditingController();
  final TextEditingController partnerNameInput = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("パートナーを追加してください。"),
            const SizedBox(
              height: 50,
              width: 50,
            ),
            Column(
              children: [
                TextField(
                  controller: partnerUidInput,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "パートナーのIDを入力してください。",
                  ),
                ),
                TextField(
                  controller: partnerNameInput,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "パートなの名前を入力してください。",
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final userId = FirebaseAuth.instance.currentUser!.uid;
                    final partnerUid = partnerUidInput.text;
                    final partnerName = partnerNameInput.text;
                    FirebaseFirestore.instance
                        .collection(userId)
                        .doc("partner")
                        .set({
                      "partnerUid": partnerUid,
                      "partnerName": partnerName,
                    });
                  },
                  child: const Text("追加"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
