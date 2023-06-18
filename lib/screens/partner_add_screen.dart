//Author : muhyun-kim
//Modified : 2023/06/07
//Function : パートナーを追加する画面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_share_schedule/models/partner_model.dart';
import 'package:couple_share_schedule/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartnerAddScreen extends ConsumerStatefulWidget {
  final String partnerUid;
  PartnerAddScreen({Key? key, required this.partnerUid});

  @override
  ConsumerState<PartnerAddScreen> createState() => _PartnerAddScreenState();
}

class _PartnerAddScreenState extends ConsumerState<PartnerAddScreen> {
  var _partnerUid;
  final TextEditingController _partnerNameInput = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _partnerUid = widget.partnerUid;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 17, 22, 17),
        ),
        backgroundColor: Color(0xFFC3E99D),
        title: Text(
          "パートナー追加",
          style: const TextStyle(
            color: Color.fromARGB(255, 57, 67, 57),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFC3E99D),
                      width: 2,
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _partnerNameInput,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: "お名前",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC3E99D),
                  ),
                  onPressed: () async {
                    final newPartner = PartnerModel(
                      partnerUid: _partnerUid,
                      partnerName: _partnerNameInput.text,
                    );
                    print(newPartner);
                    await FirebaseFirestore.instance
                        .collection(currentUserUid)
                        .doc("partner")
                        .set(newPartner.toJson());
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "追加",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
