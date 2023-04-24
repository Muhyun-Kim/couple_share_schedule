import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/screens/home_screen.dart';
import 'package:couple_share_schedule/screens/mobile_scanner_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PartnerAddScreen extends StatefulWidget {
  String partnerUid;
  PartnerAddScreen({Key? key, required this.partnerUid}) : super(key: key);

  @override
  State<PartnerAddScreen> createState() => _PartnerAddScreenState();
}

class _PartnerAddScreenState extends State<PartnerAddScreen> {
  String _partnerUid = "UIDを読み取る";
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
  void initState() {
    super.initState();
    _partnerUid = widget.partnerUid;
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
                        builder: (context) => MobileScannerScreen(
                          partnerUid: _partnerUid,
                        ),
                      ),
                    );
                  },
                  child: Text(_partnerUid),
                ),
                buildPartnerTextField(
                  _partnerNameInput,
                  "パートナーの名前を入力してください。",
                ),
                ElevatedButton(
                  onPressed: () async {
                    final partnerUid = _partnerUid;
                    final partnerName = _partnerNameInput.text;
                    await FirebaseFirestore.instance
                        .collection(userId)
                        .doc("partner")
                        .set({
                      "partnerUid": partnerUid,
                      "partnerName": partnerName,
                    });
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
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
