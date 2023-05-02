//Author : muhyun-kim
//Modified : 2023/03/15
//Function : 最初アプリを開い際、ログイン状態による画面表示

import 'package:couple_share_schedule/screens/home_screen.dart';
import 'package:couple_share_schedule/screens/loading_screen.dart';
import 'package:couple_share_schedule/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          } else {
            return const HomeScreen();
          }
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
