//Author : muhyun-kim
//Modified : 2023/05/28
//Function : ログイン状態の時、最初表示される画面

import 'dart:io';

import 'package:couple_share_schedule/provider/user_provider.dart';
import 'package:couple_share_schedule/widgets/ui_widget/login_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  //google login
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //apple login
  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3E99D),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 180,
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Text(
                        "ログインして始める",
                        style: GoogleFonts.sawarabiGothic(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await signInWithGoogle();
                            final User? user =
                                FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final userProvider =
                                  ref.read(currentUserProvider.notifier);
                              userProvider.setUser(user);
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 35,
                            child: Transform.scale(
                              scale: 0.5,
                              child: Image.asset(
                                'assets/images/google_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        if (Platform.isIOS)
                          SizedBox(
                            width: 40,
                          ),
                        if (Platform.isIOS)
                          loginButton(
                            onTap: () async {
                              await signInWithApple();
                              final User user =
                                  FirebaseAuth.instance.currentUser!;
                              final userProvider =
                                  ref.read(currentUserProvider.notifier);
                              userProvider.setUser(user);
                            },
                            assetImage: 'assets/images/apple_logo.png',
                            backgroundColor: Color.fromARGB(255, 10, 22, 10),
                            scale: 0.56,
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
