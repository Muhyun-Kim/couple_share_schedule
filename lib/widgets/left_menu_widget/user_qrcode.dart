import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQRCode extends StatelessWidget {
  const UserQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Center(
        child: QrImage(
          data: userId,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
