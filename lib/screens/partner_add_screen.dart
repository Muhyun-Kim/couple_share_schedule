import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/screens/mobile_scanner_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PartnerAddScreen extends StatefulWidget {
  const PartnerAddScreen({super.key});

  @override
  State<PartnerAddScreen> createState() => _PartnerAddScreenState();
}

class _PartnerAddScreenState extends State<PartnerAddScreen> {
  final TextEditingController _partnerUidInput = TextEditingController();
  final TextEditingController _partnerNameInput = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Widget buildPartnerTextField(
      TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
      ),
    );
  }

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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileScannerScreen(),
                      ),
                    );
                  },
                  child: const Text("UIDを読み取る"),
                ),
                buildPartnerTextField(
                  _partnerNameInput,
                  "パートナーの名前を入力してください。",
                ),
                ElevatedButton(
                  onPressed: () {
                    final partnerUid = _partnerUidInput.text;
                    final partnerName = _partnerNameInput.text;
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
